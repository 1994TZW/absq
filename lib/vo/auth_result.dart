import 'auth_status.dart';

class AuthResult {
  AuthStatus authStatus;
  String? authErrorCode;
  String? authErrorMsg;

  AuthResult({required this.authStatus, this.authErrorCode, this.authErrorMsg});
}
