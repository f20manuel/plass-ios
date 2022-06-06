import 'package:get/get.dart';
import 'package:plass/qr_code/qr_code_controller.dart';
import 'package:plass/register/register_controller.dart';
import 'package:plass/services/drivers_service.dart';

class QrCodeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DriverService());
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => QrCodeController());
  }
}