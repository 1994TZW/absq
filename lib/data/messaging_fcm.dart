import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';
import 'package:absq/helper/shared_pref.dart';
import 'package:absq/service/messaging_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:absq/vo/background_msg.dart';

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  print("Handling a background message: ${message.data}");
  var msg = BackgroundMsg.fromJson(message.data);
  print("Handling a background message msg.id: ${msg.id}");
  SharedPref.saveBackgroundMsg(msg);
  print(
      "Handling a background message: ${await SharedPref.getBackgroundMsg()}");
}

const channelID = "foresight_channel";
const channelName = "high priority foresight_channel";
const channelDesc =
    "This channel is used for important notifications for foresight.";

class MessagingFCM {
  final log = Logger('MessagingFCM');

  late FirebaseMessaging _firebaseMessaging;

  MessagingFCM(OnNotify onMessage,
      {OnNotify? onLaunch,
      OnNotify? onResume,
      OnSetupComplete? onSetupComplete}) {
    _firebaseMessaging = FirebaseMessaging.instance;
    init(onMessage: onMessage, onSetupComplete: onSetupComplete);
  }

  init({OnNotify? onMessage, OnSetupComplete? onSetupComplete}) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log.info('User granted permission: ${settings.authorizationStatus}');

    // add channel for local notification
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelID,
      channelName,
      description: channelDesc,
      importance: Importance.max,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // on message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log.info("onMessage: $message");

      if (message.notification != null) {
        log.info(
            'Message also contained a notification: ${message.notification}');
      }
      _localNoti(channel, message, onMessage);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log.info("onMessageOpenedApp: $message");

      if (message.notification != null) {
        log.info(
            'Message also contained a notification: ${message.notification}');
      }
      if (onMessage != null) {
        onMessage(Map<String, dynamic>.from(message.data));
      }
    });

    try {
      String? token = await _firebaseMessaging.getToken();
      if (onSetupComplete != null && token != null) onSetupComplete(token);
      log.info("Messaging Token:$token");
    } on Exception catch (e) {
      log.shout("Unable to get messing token:$e");
    }
  }

  _localNoti(AndroidNotificationChannel channel, RemoteMessage message,
      OnNotify? onMessage) async {
    if (message.notification == null || message.notification?.android == null) {
      log.shout("no notification");
      return;
    }

    RemoteNotification notification = message.notification!;
    AndroidNotification android = message.notification!.android!;

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (s) {
      if (onMessage != null) {
        onMessage(Map<String, dynamic>.from(message.data));
      }
      log.info("onSelectNotification:$s");
    });
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
          ),
        ));
  }

  Future<void> subscribeToTopic(String topic) {
    return _firebaseMessaging.subscribeToTopic(topic);
  }

  _onNotify(Map<String, dynamic> message, OnNotify onNotify) {
    onNotify(Map<String, dynamic>.from(message));
  }

  Future<void> unsubscribeToTopic(String topic) {
    return _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}
