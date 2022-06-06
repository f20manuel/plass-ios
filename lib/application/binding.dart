import 'package:get/get.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/services/auth_service.dart';
import 'package:plass/services/drivers_service.dart';
import 'package:plass/services/users_service.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(DriverService());
    Get.put(UsersService());
    Get.put(AuthService());
    Get.put(AppController());
  }
}