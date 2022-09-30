import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/app/enviroment/env.dart';

// ignore: avoid_classes_with_only_static_members
abstract class ConfigReader {
  static late Map<String, dynamic>? _config;

  static Future<void> initialize() async {
    final configString = await rootBundle.loadString("config/app_config.json");
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static EnvTag getDefEnv() {
    final defEnv = _config!["defEnv"] as String;
    if (defEnv == "Dev") {
      return EnvTag.dev;
    } else if (defEnv == "Stg") {
      return EnvTag.stg;
    } else {
      return EnvTag.prod;
    }
  }

  static Map<String, dynamic> getTestUser() {
    return _config!["testUser"] as Map<String, dynamic>;
  }

  static Map<String, dynamic> getTestCreditCard() {
    return _config!["testUser"]["credit_card"] as Map<String, dynamic>;
  }
}
