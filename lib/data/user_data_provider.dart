import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:absq/config.dart';
import 'package:absq/helper/api_helper.dart';
import 'package:absq/helper/firebase_helper.dart';

import 'package:logging/logging.dart';
import 'package:absq/vo/user.dart';

import '../constants.dart';

class UserDataProvider {
  final log = Logger('UserDataProvider');

  Future<User> getUser(String userID) async {
    String path = "/$user_collection";
    var snap =
        await FirebaseFirestore.instance.collection(path).doc(userID).get();
    return User.fromMap(snap.data() as Map<String, dynamic>, snap.id);
  }

  Future<User?> findUser(String phoneNumber) async {
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection(user_collection)
        .where("phone_number", isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (querySnap.docs.isNotEmpty) {
      var snap = querySnap.docs.first;
      User user = User.fromMap(snap.data() as Map<String, dynamic>, snap.id);
      return user;
    }
    return null;
  }

  Future<bool> hasInvite() async {
    var invited =
        await requestAPI("/check_invitation", "GET", token: await getToken());
    return invited["invited"];
  }

  Future<void> updateProfile(String newUserName) async {
    return await requestAPI("/users/profile", "PUT",
        payload: {"user_name": newUserName}, token: await getToken());
  }

  Future<void> updateUser(User user) async {
    return await requestAPI("/users", "PUT",
        payload: user.toMap(), token: await getToken());
  }

  Future<void> deleteInvite(String userID) async {
    return await requestAPI("/invites", "DELETE",
        payload: {"id": userID}, token: await getToken());
  }

  Future<void> acceptRequest(String userID) async {
    return await requestAPI("/accept_request", "PUT",
        payload: {
          "id": userID,
        },
        token: await getToken());
  }

  Future<void> uploadMsgToken(String token) async {
    return await requestAPI("/messages/token", "POST",
        payload: {"token": token}, token: await getToken());
  }

  Future<void> removeMsgToken(String token) async {
    return await requestAPI("/messages/token", "DELETE",
        payload: {"token": token}, token: await getToken());
  }

  Future<void> enableUser(String userID, bool enabled) async {
    return await requestAPI("/enable_user", "PUT",
        payload: {"id": userID, "enabled": enabled}, token: await getToken());
  }

  Future<void> updatePrivileges(String userID, List<String> privileges) async {
    return await requestAPI("/users/privileges", "PUT",
        payload: {"id": userID, "privileges": privileges},
        token: await getToken());
  }

  Future<List<User>> searchUser(String? term) async {
    if (term == null || term == '') return [];

    var bytes = utf8.encode(term);
    var base64Str = base64.encode(bytes);
    HtmlEscape htmlEscape = const HtmlEscape();
    String escapeBuyer = htmlEscape.convert(base64Str);

    int limit = 20;
    List<User> users = [];

    try {
      var data = await requestAPI(
          "/api/fts/$user_collection/$escapeBuyer/$limit", "GET",
          token: await getToken());

      if (data == null) return [];

      data.forEach((buyer) {
        var user = User.fromJson(buyer);
        users.add(user);
      });
    } catch (e) {
      log.warning("buyer error:" + e.toString());
      return [];
    }
    return users;
  }

  Future<void> assignCustomer(
      String userID, String customerID, String stationID) async {
    return await requestAPI("/assign_customer", "PUT",
        payload: {
          "id": userID,
          "customer_id": customerID,
          "station_id": stationID
        },
        token: await getToken());
  }

  Future<void> unAssignCustomer(String userID, String customerID) async {
    return await requestAPI("/assign_customer", "DELETE",
        payload: {
          "id": userID,
          "customer_id": customerID,
        },
        token: await getToken());
  }
}
