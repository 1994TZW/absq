import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'app.dart';
import 'config.dart';
import 'data/messaging_fcm.dart';
import 'package:daisy_client/daisy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  await Firebase.initializeApp();
  Daisy.initializeApp(
      options: const DaisyOptions(
          serverUrl:
              "https://asia-northeast1-mokkon-daisy-dev1.cloudfunctions.net/API",
          // "http://192.168.100.7:7777",
          appID: "tWNF7IqzpdBeOVhtPseu",
          projectID: "MC7jAacIPU1BEMnZ3OcZ"));

  Config(
      flavor: Flavor.DEV,
      color: Colors.blue,
      // apiURL: "http://192.168.100.7:7771",
      apiURL: "https://asia-northeast1-sme-dev1.cloudfunctions.net/API3",
      level: Level.ALL);
  runApp(App());
}
