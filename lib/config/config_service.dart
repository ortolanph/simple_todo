import 'dart:convert';

import 'package:flutter/services.dart';

class ConfigService {
  static const String selectedEnviroment =
      String.fromEnvironment('ENVIRONMENT', defaultValue: "dev");

  static String get currentEnv => selectedEnviroment;
  static bool get isDevelopment => selectedEnviroment == "dev";
  static String get licensedTo => isDevelopment
      ? "DEFAULT_USER"
      : String.fromEnvironment('LICENSED_TO', defaultValue: "pro");
  static String get guestbookSystemName => isDevelopment
      ? "DEFAULT_LICENSE"
      : String.fromEnvironment('LICENSE_KEY', defaultValue: "pro");
}
