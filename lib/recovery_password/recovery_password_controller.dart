import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:plass/firestore.dart';
import 'package:plass/services/auth_service.dart';

class RecoveryPasswordController extends GetxController {
  // variables
  var email = ''.obs;

  // instances
  final auth = FirebaseAuth.instance;

  // services
  final AuthService service = Get.find();

  // fields controllers
  final emailController = TextEditingController().obs;

  Future recovery() async {
    try {
      await auth.sendPasswordResetEmail(email: email.value);
      emailController.value.clear();
      Get.back(result: email.value);
    } on FirebaseAuthException catch(e) {
      Get.snackbar("Ocurrió un error", e.message.toString());
      Firestore.generateLog(e, 'Line 20 in lib/recovery_password/recovery_password_controller.dart');
    }
  }
}