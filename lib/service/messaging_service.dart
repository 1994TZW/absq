typedef OnNotify = Function(Map<String, dynamic> message);
typedef OnSetupComplete = Function(String token);

abstract class MessagingService {
  void init(OnNotify onMessage,
      {OnNotify? onLaunch,
      OnNotify? onResume,
      OnSetupComplete? onSetupComplete});
  Future<void> subscribe(String topic);
  Future<void> unsubscribe(String topic);
}
