import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daisy_client/daisy.dart';
import 'package:absq/helper/api_helper.dart';
import 'package:absq/pagination/paginator_listener.dart';
import 'package:absq/service/services.dart';
import 'package:absq/vo/user.dart';

import '../constants.dart';
import 'base_model.dart';

class UserModel extends BaseModel {
  PaginatorListener<User>? customers;
  int selectedIndex = 0;

  List<User> users = [
    User(id: "1", name: "Mg Mg", phoneNumber: "09 111111111"),
    User(id: "2", name: "Mg Zaw Tun", phoneNumber: "09 222222222"),
    User(id: "3", name: "Mg Myo Kyaw", phoneNumber: "09 333333333")
  ];

  User? findUser(String phone) {
    return users.firstWhere((e) => e.phoneNumber == phone);
  }

  @override
  void privilegeChanged() {
    if (user!.hasAccount()) {
      load();
    }
  }

  load() {
    String path = "/$user_collection";
    Query col = FirebaseFirestore.instance.collection(path);
    Query pageQuery = FirebaseFirestore.instance.collection(path);
    if (selectedIndex == 0) {
      pageQuery = pageQuery.orderBy("user_name");
    }
    if (selectedIndex == 1) {
      pageQuery = pageQuery
          .where("is_employee", isEqualTo: false)
          .where("is_sys_admin", isEqualTo: false);
    }
    if (selectedIndex == 2) {
      pageQuery = pageQuery.where('status', isEqualTo: user_invited_status);
    }
    if (selectedIndex == 3) {
      pageQuery = pageQuery.where("status", isEqualTo: user_requested_status);
    }
    if (selectedIndex == 4) {
      pageQuery = pageQuery.where("status", isEqualTo: user_joined_status);
    }
    if (selectedIndex == 5) {
      pageQuery = pageQuery.where("status", isEqualTo: user_disabled_status);
    }
    customers?.close();
    customers = PaginatorListener<User>(
        col, pageQuery, (data, id) => User.fromMap(data, id), onChange: () {
      notifyListeners();
    }, rowPerLoad: 30);
  }

  @override
  void logout() {
    customers?.close();
  }

  Future<void> approveMemberRequest(String userID) async {
    return Services.instance.userService.acceptRequest(userID);
  }

  Future<User?> findUserByPhone(String phoneNumber) {
    return Services.instance.userService.findUser(phoneNumber);
  }

  Future<void> enableMember(String userID, bool enabled) async {
    return Services.instance.userService.enableUser(userID, enabled);
  }

  Future<void> deleteInvitation(String userID) async {
    return Services.instance.userService.deleteInvite(userID);
  }

  Future<void> assignCustomer(
      String userId, String customerId, String stationId) async {
    return Services.instance.userService
        .assignCustomer(userId, customerId, stationId);
  }

  Future<void> unAssignCustomer(String userId) async {
    return Services.instance.dataService
        .delete({"id": userId}, "/assign_customer");
  }

  Future<User?> getUser(String id) async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection("/$user_collection")
          .doc(id)
          .get(const GetOptions(source: Source.server));
      var user = User.fromMap(snap.data() as Map<String, dynamic>, snap.id);

      return user;
    } catch (e) {
      log.warning("Error!! $e");
    }
    return null;
  }

  Future<void> updateUserNameAndPhoneNumber(
      String userId, String userName, String phoneNumber) async {
    var payload = {
      "id": userId,
      "user_name": userName,
      "phone_number": phoneNumber
    };
    return Services.instance.dataService.update(payload, "/users");
  }

  Future<void> delete(String userId) async {
    return Services.instance.dataService.delete({"id": userId}, "/users");
  }

  Future<List<User>> getUsersByStation(String? stationId) async {
    if (stationId == null || stationId == '') return [];

    try {
      String path = "/$user_collection";
      var querySnap = await FirebaseFirestore.instance
          .collection(path)
          .where("station_id", isEqualTo: stationId)
          .where("delete_time", isEqualTo: 0)
          .orderBy("update_time")
          .get(const GetOptions(source: Source.server));
      return querySnap.docs.map((e) => User.fromMap(e.data(), e.id)).toList();
    } catch (e) {
      log.warning("getUsersByStation error:" + e.toString());
      return [];
    }
  }

  Future<List<User>> searchUser(String term) async {
    final string = term;
    final newString = string.replaceAll('+', '');
    List<Map<String, dynamic>>? records =
        await Daisy.app().fts('users', newString);
    return records!.map((e) => User.fromDbMap(e)).toList();
  }

  changeFilterIndex(int _selectedIndex) {
    selectedIndex = _selectedIndex;
    load();
    notifyListeners();
  }
}
