import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/driver.dart';
import 'package:plass/models/user.dart';
import 'package:plass/qr_code/qr_code_binding.dart';
import 'package:plass/qr_code/qr_code_page.dart';
import 'package:plass/register/register_binding.dart';
import 'package:plass/register/register_page.dart';
import 'package:plass/services/auth_service.dart';
import 'package:plass/services/drivers_service.dart';

class RegisterArguments {
  final DriverModel referred;

  RegisterArguments({
    required this.referred,
  });
}

class RegisterController extends GetxController {
  RegisterArguments? args = Get.arguments;
  var securePassword = true.obs;
  var phoneBorderWidth = 1.0.obs;
  var phoneBorderColor = Colors.grey.obs;
  var gender = Gender.male.obs;
  var acceptedTerms = false.obs;
  var loadingRegister = false.obs;

  final auth = FirebaseAuth.instance;
  final AuthService authService = Get.find();

  void register(String firstName, String lastName, String email, String phone, String password, Gender male) async {
    try {
      loadingRegister.value = true;
      await authService.register(
        firstName,
        lastName,
        email,
        phone,
        password,
        gender.value,
        args
      );
      loadingRegister.value = false;
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
    } catch (exception) {
      Firestore.generateLog(exception, 'Function register in lib/register/register_controller.dart');
    }
  }

  @override
  void onClose() {
    loadingRegister.value = false;
    super.onClose();
  }
}