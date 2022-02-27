import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/vo/setting.dart';
import 'package:absq/vo/user.dart';

import 'signup_page.dart';

navigateAfterAuthVerified(BuildContext context) async {
  User? user = Provider.of<MainModel>(context, listen: false).user;
  Setting? setting = Provider.of<MainModel>(context, listen: false).setting;

  if (setting == null) return;

  if (user != null && (user.isJoined || user.isRequested)) {
    await Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
  } else {
    if (setting.inviteRequired) {
      bool invited =
          await Provider.of<MainModel>(context, listen: false).hasInvite();
      if (!invited) {
        // await Navigator.of(context).pushAndRemoveUntil(
        //     CupertinoPageRoute(builder: (context) => RequestInvitationPage()),
        //     (r) => false);
        return;
      }
    }
    await Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => SignupPage()), (r) => false);
  }
}
