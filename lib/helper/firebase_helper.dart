import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

final log = Logger('firebaseHelper');

final FirebaseAuth auth = FirebaseAuth.instance;

Future<String> getToken() async {
  User? firebaseUser = auth.currentUser;
  String? token = await firebaseUser?.getIdToken();
  return token ?? "";
}

Future<Map> getClaims({bool refreshIdToken = false}) async {
  User? firebaseUser = auth.currentUser;
  if (firebaseUser == null) return {};
  IdTokenResult idToken = await firebaseUser.getIdTokenResult(refreshIdToken);
  return idToken.claims ?? {};
}
