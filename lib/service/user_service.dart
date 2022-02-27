import 'package:absq/vo/user.dart';

abstract class UserService {
  Future<void> updateUser(User user);
  Future<void> updateProfile(String newUserName);
  Future<bool> hasInvite();

  Future<void> deleteInvite(String userID);
  Future<void> acceptRequest(String userID);
  Future<User?> findUser(String phoneNumber);
  Future<List<User>> searchUser(String term);
  Future<void> uploadMsgToken(String token);
  Future<void> removeMsgToken(String token);
  Future<void> enableUser(String userID, bool enabled);
  Future<void> updatePrivileges(String userID, List<String> privileges);
  Future<void> assignCustomer(
      String userID, String customerID, String stationID);
  Future<void> unAssignCustomer(String userID, String customerID);
  Future<User> getUser(String userID);
}
