import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

enum Flavor { DEV, STAGING, PRODUCTION, LOCAL }
const FlavorNames = ["Development", "Staging", "Production", "Local"];

class Config {
  static Config? _instance;

  final Flavor flavor;
  final String name;
  final Color color;
  final String apiURL;
  final Level level;

  factory Config(
      {required Flavor flavor,
      required String apiURL,
      Color color = Colors.blue,
      Level level = Level.SEVERE}) {
    _instance ??= Config._internal(
        flavor, FlavorNames[flavor.index], color, apiURL, level);

    Logger.root.level = level;
    Logger.root.onRecord.listen((record) {
      print(
          '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
    });

    return _instance!;
  }

  Config._internal(this.flavor, this.name, this.color, this.apiURL, this.level);
  static Config get instance {
    return _instance!;
  }

  static bool isProduction() => _instance!.flavor == Flavor.PRODUCTION;
  static bool isDevelopment() => _instance!.flavor == Flavor.DEV;
  static bool isStaging() => _instance!.flavor == Flavor.STAGING;
  static bool isLocal() => _instance!.flavor == Flavor.LOCAL;
}
