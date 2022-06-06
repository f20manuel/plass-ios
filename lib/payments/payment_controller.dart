import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:plass/models/user_payment_method.dart';
import 'package:plass/payments/payment_repository.dart';
import 'package:plass/services/payment_service.dart';

class PaymentController extends GetxController with PaymentRepository{
  @override
  void onInit() {
    paymentMethodsList.bindStream(streamByUser(auth.currentUser));
    myPaymentsList.bindStream(streamByUser2(auth.currentUser));
    super.onInit();
  }

  @override
  void onClose() {
    paymentMethodsList.close();
    super.onClose();
  }
}