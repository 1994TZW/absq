import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:absq/vo/auth_result.dart';
import 'package:absq/vo/auth_status.dart';
import 'package:absq/vo/user.dart' as sme;
import 'package:absq/vo/setting.dart';
import 'package:absq/exceiptions/signin_exception.dart';
import 'package:absq/helper/api_helper.dart';
import 'package:absq/helper/firebase_helper.dart';
import 'package:logging/logging.dart';

import '../constants.dart';

class AuthFb {
  final log = Logger('AuthFb');

  static final AuthFb instance = AuthFb._();
  AuthFb._();

  late StreamController<sme.User?> controller;
  static final FirebaseAuth _fb = FirebaseAuth.instance;
  static String? _verificationId;
  StreamSubscription<DocumentSnapshot>? userListener;

  Future<AuthResult> sendSmsCodeToPhoneNumber(String phoneNumber) {
    Completer<AuthResult> completer = Completer();
    bool codeSentCompleted = false;

    _fb.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 0),
        verificationCompleted: (AuthCredential credential) async {
          UserCredential _authResult;
          try {
            _authResult = await _fb.signInWithCredential(credential);
            log.info("PhoneVerificationCompleted :$_authResult");
          } catch (e) {
            log.info("Exception:$e");
            completer.completeError(SigninException(e.toString()));
            return;
          }
          AuthResult auth = AuthResult(authStatus: AuthStatus.AUTH_VERIFIED);
          completer.complete(auth);
          log.info(
              'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: ${_authResult.user}');
        },
        verificationFailed: (FirebaseAuthException authException) async {
          log.info(
              'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
          completer.completeError(SigninException(
              "Phone number verification failed:${authException.message}"));
        },
        codeSent: (String verificationId, [int? forceResendingToken]) async {
          _verificationId = verificationId;
          log.info("codeSent  " + phoneNumber);
          codeSentCompleted = true;
          if (!completer.isCompleted) {
            completer.complete(AuthResult(authStatus: AuthStatus.SMS_SENT));
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log.info("codeAutoRetrievalTimeout $verificationId ");
          _verificationId = verificationId;
          if (codeSentCompleted) {
            if (!completer.isCompleted) {
              completer.complete(AuthResult(authStatus: AuthStatus.SMS_SENT));
            }
          } else {
            completer.completeError(SigninException("SMS code failed"));
          }
        });

    return completer.future;
  }

  Future<AuthResult> signInWithPhoneNumber(String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId ?? "",
        smsCode: smsCode,
      );
      await _fb.signInWithCredential(credential);
      await _addUserToStream(refreshIdToken: true);
    } on Exception catch (e) {
      return Future.error(SigninException(e.toString()));
    }
    return Future.value(AuthResult(authStatus: AuthStatus.AUTH_VERIFIED));
  }

  Future<void> signout() async {
    await userListener?.cancel();
    return _fb.signOut();
  }

  Future<void> _addUserToStream({bool refreshIdToken = false}) async {
    User? firebaseUser = _fb.currentUser;
    if (firebaseUser == null) return;

    Map claims = await getClaims(refreshIdToken: refreshIdToken);
    log.info("Claims:$claims");

    String? cid = claims["s_cid"];
    sme.User? user;
    if (cid != null && cid != "") {
      user = await _getUserFromFirestore(cid);
    }

    if (user == null) {
      controller.add(null);
      return;
    }

    loadUserClaim(claims, user);

    controller.add(user);
  }

  loadUserClaim(Map claims, sme.User user) {
    // add privileges
    String? privileges = claims["s_pr"];
    if (privileges != null && privileges != "") {
      user.privileges = privileges.split(":").toList();
    } else {
      user.privileges = [];
    }

    user.customerID = claims["s_cus"];
  }

  Future<sme.User?> _getUserFromFirestore(String userID) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection(user_collection)
        .doc(userID)
        .get();
    if (snap.exists) {
      sme.User user =
          sme.User.fromMap(snap.data() as Map<String, dynamic>, snap.id);
      return user;
    }
    return null;
  }

  Future<bool> isLogin() async {
    final User? firebaseUser = _fb.currentUser;
    return Future.value(firebaseUser != null);
  }

  Future<void> signup(String userName) async {
    await requestAPI("/signup", "POST",
        payload: {
          'user_name': userName,
        },
        token: await getToken());
    await _addUserToStream(refreshIdToken: true);
    _startUserListener();
    return;
  }

  Future<void> joinInvite(String userName) async {
    await requestAPI("/join_invite", "POST",
        payload: {
          'user_name': userName,
        },
        token: await getToken());
    // refresh token once signup
    await _addUserToStream(refreshIdToken: true);
    _startUserListener();
    return;
  }

  Future<void> scanQrcode(String qrcode) async {
    await requestAPI("/scan_qrcode", "POST",
        payload: {"id": qrcode}, token: await getToken());
    return;
  }

  Future<String> getToken() async {
    User? firebaseUser = _fb.currentUser;
    String token = await firebaseUser?.getIdToken() ?? "";
    return token;
  }

  Future<Setting?> getSetting() async {
    print("getSetting");
    var snap = await FirebaseFirestore.instance
        .collection(config_collection)
        .doc(setting_doc_id)
        .get();
    if (!snap.exists) {
      return null;
    }
    return Setting.fromMap(snap.data() as Map<String, dynamic>);
  }

  Stream<Setting> settings() async* {
    print("settings");
    Stream<DocumentSnapshot> snapshot = FirebaseFirestore.instance
        .collection(config_collection)
        .doc(setting_doc_id)
        .snapshots();

    await for (var snap in snapshot) {
      Setting setting = Setting.fromMap(snap.data() as Map<String, dynamic>);
      yield setting;
    }
  }

  Future<String?> _getCurrentUserID() async {
    User? firebaseUser = _fb.currentUser;
    if (firebaseUser == null) return null;
    Map claims = await getClaims();
    String? cid = claims["s_cid"];
    return cid;
  }

  Future<void> _startUserListener() async {
    userListener?.cancel();
    String? _userID = await _getCurrentUserID();
    if (_userID == null) {
      return;
    }

    Stream<DocumentSnapshot> snapshot = FirebaseFirestore.instance
        .collection(user_collection)
        .doc(_userID)
        .snapshots();
    userListener = snapshot.listen((snap) async {
      if (snap.exists) {
        sme.User user =
            sme.User.fromMap(snap.data() as Map<String, dynamic>, snap.id);

        User? firebaseUser = _fb.currentUser;
        if (firebaseUser == null) {
          userListener?.cancel();
          return;
        }

        // get privilege from claim
        Map<dynamic, dynamic> claims = await getClaims(refreshIdToken: true);
        loadUserClaim(claims, user);

        controller.add(user);
      }
    });
  }

  Stream<sme.User?> user() {
    // ignore: close_sinks
    StreamSubscription<User?>? authListener;

    Future<void> _start() async {
      authListener = _fb.authStateChanges().listen((firebaseUser) async {
        if (firebaseUser == null) {
          controller.add(null);
        } else {
          _addUserToStream(refreshIdToken: true);
          _startUserListener();
        }
      });
    }

    void _stop() {
      userListener?.cancel();
      authListener?.cancel();
    }

    controller = StreamController<sme.User?>(
        onListen: _start, onPause: _stop, onResume: _start, onCancel: _stop);

    return controller.stream;
  }
}
