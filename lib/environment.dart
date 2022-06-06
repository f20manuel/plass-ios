import 'package:plass/environment_base.dart';
import 'package:plass/environment_dev.dart';
import 'package:plass/environment_pro.dart';
import 'package:plass/environment_test.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String dev = 'DEV';
  static const String pro = 'PRO';
  static const String test = 'TEST';

  late EnvironmentBase config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  EnvironmentBase _getConfig(String environment) {
    switch (environment) {
      case Environment.pro:
        return EnvironmentPro();
      case Environment.dev:
        return EnvironmentDev();
      default:
        return EnvironmentTest();
    }
  }
}