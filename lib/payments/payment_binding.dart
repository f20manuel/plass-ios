import 'package:get/get.dart';
import 'package:plass/payments/payment_controller.dart';
import 'package:plass/services/payment_service.dart';

class PaymentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentService());
    Get.lazyPut(() => PaymentController());
  }
}