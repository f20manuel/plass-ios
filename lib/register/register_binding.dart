import 'package:get/get.dart';
import 'package:plass/register/register_controller.dart';
import 'package:plass/services/drivers_service.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }
}