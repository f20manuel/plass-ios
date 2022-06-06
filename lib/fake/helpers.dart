import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Helpers {
  Helpers._();

  static String getTime() {
    return DateFormat("hh:mm:ss a").format(DateTime.now());
  }

  static void printData(String text) {
    debugPrint("\x1B[37m$text\x1B[0m");
  }

  static void printAction(String text) {
    debugPrint("\x1B[34m$text\x1B[0m");
  }

  static void printSuccess(String text) {
    debugPrint("\x1B[34m$text\x1B[0m");
  }

  static void printWarning(String text) {
    debugPrint("\x1B[33m$text\x1B[0m");
  }

  static void printError(String text) {
    debugPrint("\x1B[31m$text\x1B[0m");
  }

  static void printDivider() {
    debugPrint("------------------------------------------");
  }

  static void printSeparator() {
    debugPrint("==========================================");
  }
}