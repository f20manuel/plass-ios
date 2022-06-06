import 'package:get/get.dart';
import 'package:plass/services/sms_service.dart';
import 'package:plass/verify_phone/verify_phone_controller.dart';
import 'package:plass/widgets/change_phone_number/change_phone_controller.dart';

class VerifyPhoneBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SmsService());
    Get.lazyPut(() => VerifyPhoneController());
    Get.lazyPut(() => ChangePhoneNumberController());
  }
}