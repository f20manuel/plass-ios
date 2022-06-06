import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plass/app/data/providers/firestore.dart';
import 'package:plass/app/modules/select_payment_method/select_payment_method_arguments.dart';
import 'package:plass/app/modules/select_payment_method/select_payment_method_binding.dart';
import 'package:plass/app/modules/select_payment_method/select_payment_method_page.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/payment_method.dart';
import 'package:plass/models/user_payment_method.dart';

class PaymentRepository {
  // Variables
  var paymentMethodsList = Rx<List<UserPaymentMethodModel>>([]);
  var myPaymentsList = Rx<List<String>>([]);

  // Gets
  List<UserPaymentMethodModel> get paymentMethods => paymentMethodsList.value;
  List<String> get myPayments => myPaymentsList.value;

  // Instances
  final auth = FirebaseAuth.instance;

  Stream<List<UserPaymentMethodModel>> streamByUser(User? user) {
    return Collection.userPaymentMethods
      .where('user_uid', isEqualTo: user!.uid)
      .snapshots()
      .map((querySnapshot) {
        List<UserPaymentMethodModel> data = [];
        for (DocumentSnapshot document in querySnapshot.docs) {
          UserPaymentMethodModel model = UserPaymentMethodModel.fromDocumentSnapshot(document);
          data.add(model);
        }
        return data;
      });
  }

  Stream<List<String>> streamByUser2(User? user) {
    return Collection.userPaymentMethods
      .where('user_uid', isEqualTo: user!.uid)
      .snapshots()
      .map((querySnapshot) {
        List<String> data = [];
        for (DocumentSnapshot document in querySnapshot.docs) {
          UserPaymentMethodModel model = UserPaymentMethodModel.fromDocumentSnapshot(document);
          data.add(model.name.toLowerCase());
        }
        return data;
      });
  }

  Future<void> openPaymentListModal() async {
    PaymentMethod? result = await Get.to(
      () => const SelectPaymentMethodPage(),
      binding: SelectPaymentMethodBinding(),
      fullscreenDialog: true,
      arguments: SelectPaymentMethodArguments(
        myPayments: myPayments
      )
    );

    if (result != null) {
      UserPaymentMethodModel model = UserPaymentMethodModel(
        currency: result.currency,
        image: result.logoUrl,
        imageType: 'image',
        name: result.name,
        active: false,
        user: Firestore.collection('users').doc(auth.currentUser?.uid)
      );

      await model.add();
    }
  }
}