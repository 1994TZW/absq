import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:absq/data/user_data_provider.dart';
import 'package:absq/vo/user.dart';

import 'user_service.dart';

class UserServiceImp implements UserService {
  UserServiceImp({
    this.connectivity,
    required this.userDataProvider,
  });

  final Connectivity? connectivity;
  final UserDataProvider userDataProvider;

  @override
  Future<User> getUser(String userID) {
    return userDataProvider.getUser(userID);
  }

  @override
  Future<void> deleteInvite(String userID) {
    return userDataProvider.deleteInvite(userID);
  }

  @override
  Future<void> acceptRequest(String userID) {
    return userDataProvider.acceptRequest(userID);
  }

  @override
  Future<User?> findUser(String phoneNumber) {
    return userDataProvider.findUser(phoneNumber);
  }

  @override
  Future<List<User>> searchUser(String term) {
    return userDataProvider.searchUser(term);
  }

  @override
  Future<void> removeMsgToken(String token) {
    return userDataProvider.removeMsgToken(token);
  }

  @override
  Future<void> uploadMsgToken(String token) {
    return userDataProvider.uploadMsgToken(token);
  }

  @override
  Future<bool> hasInvite() {
    return userDataProvider.hasInvite();
  }

  @override
  Future<void> updateProfile(String newUserName) {
    return userDataProvider.updateProfile(newUserName);
  }

  @override
  Future<void> updateUser(User user) {
    return userDataProvider.updateUser(user);
  }

  @override
  Future<void> enableUser(String userID, bool enabled) {
    return userDataProvider.enableUser(userID, enabled);
  }

  @override
  Future<void> updatePrivileges(String userID, List<String> privileges) {
    return userDataProvider.updatePrivileges(userID, privileges);
  }

  @override
  Future<void> assignCustomer(
      String userID, String customerID, String stationID) {
    return userDataProvider.assignCustomer(userID, customerID, stationID);
  }

  @override
  Future<void> unAssignCustomer(String userID, String customerID) {
    return userDataProvider.unAssignCustomer(userID, customerID);
  }
}
