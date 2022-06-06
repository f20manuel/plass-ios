import 'package:get/get.dart';
import 'package:plass/app/modules/select_payment_method/select_payment_method_repository.dart';

class SelectPaymentMethodController extends GetxController with SelectPaymentMethodRepository {
  @override
  void onInit() {
    paymentMethodList.bindStream(streamPaymentMethods());
    print(arguments.myPayments);
    super.onInit();
  }

  @override
  void onClose() {
    paymentMethodList.close();
    super.onClose();
  }
}