import 'package:get/get.dart';

extension Enums on GetInterface {
  String enumToString(dynamic _enum) {
    return _enum.toString().split('.')[1];
  }
  dynamic stringToEnum(dynamic _enum, String value) {
    return _enum[value];
  }
}