import 'package:get/get.dart';
import 'package:plass/help/others/others_controller.dart';
import 'package:plass/services/help/others_service.dart';

class OthersBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OthersService());
    Get.lazyPut(() => OthersController());
  }
}