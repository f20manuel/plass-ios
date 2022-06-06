import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/firestore.dart';
import 'package:plass/services/users_service.dart';
import 'package:plass/verify_phone/verify_phone_binding.dart';
import 'package:plass/verify_phone/verify_phone_page.dart';

class ChangePhoneNumberController extends GetxController {
  var phoneBorderWidth = 1.0.obs;
  var phoneBorderColor = Colors.grey.obs;
  var mobile = ''.obs;

  final AppController auth = Get.find();
  final UsersService usersService = Get.find();

  @override
  void onInit() {
    mobile.value = auth.userInfo.mobile;
    super.onInit();
  }

  changeNumber() async {
    try {
      await usersService.updateAuth({
        'sms_code': '',
        'mobile': mobile.value
      });

      Get.offAll(() => const VerifyPhonePage(), binding: VerifyPhoneBinding());
    } on SocketException catch (_) {
      Get.snackbar('¡Oops!', '¡Su conexión a internet ha fallado!');
    } on FirebaseException catch (e) {
      Firestore.generateLog(e, 'Line 25 in lib/widgets/change_phone_number/change_phone_controller.dart');
    }
  }

  onChangeNumber(String value) {
    if (value.length <= 10) {
      mobile.value = '+57$value';
    }
  }
}