import 'package:get/get.dart';
import 'package:plass/recovery_password/recovery_password_controller.dart';
import 'package:plass/services/auth_service.dart';

class RecoveryPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => RecoveryPasswordController());
  }
}