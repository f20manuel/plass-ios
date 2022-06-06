import 'package:get/get.dart';
import 'package:plass/help/help_controller.dart';
import 'package:plass/services/help_service.dart';

class HelpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpService());
    Get.lazyPut(() => HelpController());
  }
}