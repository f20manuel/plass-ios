import 'package:get/get.dart';
import 'package:plass/settings/privacy/privacy_controller.dart';

class PrivacyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrivacyController());
  }
}