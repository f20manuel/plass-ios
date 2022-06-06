import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:plass/app/data/providers/firestore.dart';
import 'package:plass/app/modules/select_payment_method/select_payment_method_arguments.dart';
import 'package:plass/models/payment_method.dart';

class SelectPaymentMethodRepository {
  // Arguments
  SelectPaymentMethodArguments arguments = Get.arguments;

  var paymentMethodList = Rx<List<PaymentMethod>>([]);
  List<PaymentMethod> get paymentMethods => paymentMethodList.value;

  // Instances
  final auth = FirebaseAuth.instance;

  Stream<List<PaymentMethod>> streamPaymentMethods() {
    return Collection.paymentMethods
      .where('active', isEqualTo: true)
      .snapshots()
      .map((querySnapshot) {
        List<PaymentMethod> data = [];
        if (querySnapshot.docChanges.isNotEmpty) {
          data.clear();
        }
        for (DocumentSnapshot document in querySnapshot.docs) {
          PaymentMethod model = PaymentMethod.fromDocumentSnapshot(document);
          if (!arguments.myPayments.contains(model.name.toLowerCase())) {
            data.add(model);
          }
        }
        return data;
    });
  }
}