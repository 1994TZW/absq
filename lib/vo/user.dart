import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

DateFormat dayFormat = DateFormat("MMM dd yyyy");
DateFormat timeFormat = DateFormat("HH:mm");

class User {
  String id;
  String name;
  String phoneNumber;
  String? position;
  String? company;
  String? status;
  String? roleID;
  String? roleName;
  String? customerID;
  String? customerName;
  String? stationID;
  String? stationName;
  int unseenNotificationCount;
  //for support
  bool isLeader;

  String? storeId;
  String? storeName;
  bool isAdmin;

  bool get isInvited => status == user_invited_status;
  bool get isJoined => status != null && status == user_joined_status;
  bool get isRequested => status != null && status == user_requested_status;
  bool get isEnabled => status != user_disabled_status;

  List<String> privileges = [];

  String get phone => phoneNumber.startsWith("+959")
      ? "0${phoneNumber.substring(3)}"
      : phoneNumber;

  User(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      this.status,
      this.privileges = const [],
      this.position,
      this.company,
      this.roleID,
      this.roleName,
      this.customerID,
      this.customerName,
      this.stationID,
      this.stationName,
      this.isLeader = false,
      this.unseenNotificationCount = 0,
      this.storeId,
      this.storeName,
      this.isAdmin = false});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['user_name'],
      phoneNumber: json['phone_number'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_name': name,
        'phone_number': phoneNumber,
      };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_name': name,
      'phone_number': phoneNumber,
      'position': position,
      'company': company,
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String docID) {
    List<String> _privileges =
        map['privileges'] == null ? [] : map['privileges'].cast<String>();

    return User(
        id: docID,
        name: map['user_name'],
        phoneNumber: map['phone_number'],
        status: map['status'],
        customerID: map['customer_id'],
        customerName: map['customer_name'],
        stationID: map['station_id'],
        stationName: map['station_name'],
        position: map['position'],
        roleID: map['role_id'],
        roleName: map['role_name'],
        privileges: _privileges,
        unseenNotificationCount: map['unseen_notification_count'] ?? 0);
  }
  factory User.fromDbMap(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        name: map['user_name'],
        phoneNumber: map['phone_number'],
        status: map['status'],
        customerID: map['customer_id'],
        customerName: map['customer_name'],
        stationID: map['station_id'],
        stationName: map['station_name'],
        position: map['position'],
        roleID: map['role_id'],
        roleName: map['role_name'],
        unseenNotificationCount: map['unseen_notification_count'] ?? 0);
  }

  bool diffPrivileges(User another) {
    another.privileges.sort((a, b) => a.compareTo(b));
    privileges.sort((a, b) => a.compareTo(b));
    return !listEquals(another.privileges, privileges);
  }

  bool isCustomer() {
    return customerID != null && customerID != "";
  }

  bool isEmployee() {
    return privileges.isNotEmpty;
  }

  bool hasSysAdmin() {
    return privileges.contains('sa');
  }

  bool hasAdmin() {
    return hasSysAdmin() || privileges.contains('admin');
  }

  bool hasSupport() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('su');
  }

  bool hasProject() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('prj');
  }

  bool hasAccount() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('acc');
  }

  bool hasVendor() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('vd');
  }

  bool hasSupplier() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('sp');
  }

  bool hasWarehouse() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('wh');
  }

  bool hasModel() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('md');
  }

  bool hasMainCategory() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('mc');
  }

  bool hasPartCategory() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('pc');
  }

  bool hasTask() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('task');
  }

  bool hasProduct() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('prd');
  }

  bool hasDevice() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('dev');
  }

  bool hasPO() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('po');
  }

  bool hasGoodsReceivedNote() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('grn');
  }

  bool hasDO() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('do');
  }

  bool hasStockTransfer() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('st');
  }

  bool hasInventoryTaking() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('inv');
  }

  bool hasDamagedStock() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('ds');
  }

  bool hasReturnedStock() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('rs');
  }

  bool hasVendorWarranty() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('vw');
  }

  bool hasWarrantyReturn() {
    return hasSysAdmin() || hasAdmin() || privileges.contains('wr');
  }

  @override
  bool operator ==(Object other) => other is User && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User{id:$id, name: $name, phoneNumber: $phoneNumber,status:$status}';
  }
}
