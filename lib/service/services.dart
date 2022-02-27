import 'package:absq/data/auth_fb.dart';
import 'package:absq/data/common_data_provider.dart';
import 'package:absq/data/data_provider.dart';
import 'package:absq/data/user_data_provider.dart';
import 'package:absq/service/common_imp.dart';
import 'package:absq/service/messaging_imp.dart';
import 'package:absq/service/messaging_service.dart';
import 'package:absq/service/user_imp.dart';
import 'package:absq/service/user_service.dart';

import 'auth_imp.dart';
import 'auth_service.dart';
import 'common_service.dart';
import 'data_imp.dart';
import 'data_service.dart';

class Services {
  static final Services instance = Services._();

  late AuthService _authService;
  late UserService _userService;
  late CommonService _commonService;
  late DataService _dataService;
  late MessagingService _messagingService;
  Services._() {
    _authService = AuthServiceImp(
      authFb: AuthFb.instance,
      connectivity: null,
    );
    _userService = UserServiceImp(
        connectivity: null, userDataProvider: UserDataProvider());
    _dataService =
        DataServiceImp(connectivity: null, dataProvider: DataProvider());

    _commonService = CommonServiceImp(
        connectivity: null, commonDataProvider: CommonDataProvider());
    _messagingService = MessagingServiceImp();
  }

  AuthService get authService => _authService;
  UserService get userService => _userService;
  DataService get dataService => _dataService;
  CommonService get commonService => _commonService;
  MessagingService get messagingService => _messagingService;
}
