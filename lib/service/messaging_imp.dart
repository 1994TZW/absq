import 'package:absq/data/messaging_fcm.dart';

import 'messaging_service.dart';

class MessagingServiceImp implements MessagingService {
  MessagingServiceImp();

  static late MessagingFCM messagingFCM;

  @override
  void init(onMessage,
      {OnNotify? onLaunch,
      OnNotify? onResume,
      OnSetupComplete? onSetupComplete}) {
    messagingFCM = MessagingFCM(onMessage,
        onLaunch: onLaunch,
        onResume: onResume,
        onSetupComplete: onSetupComplete);
  }

  @override
  Future<void> subscribe(String topic) {
    return messagingFCM.unsubscribeToTopic(topic);
  }

  @override
  Future<void> unsubscribe(String topic) {
    return messagingFCM.unsubscribeToTopic(topic);
  }
}
