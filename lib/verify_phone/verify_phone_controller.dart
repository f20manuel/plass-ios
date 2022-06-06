import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/user.dart';
import 'package:plass/services/sms_service.dart';

class VerifyPhoneController extends GetxController {
  var code = ''.obs;
  var refCode = '123456'.obs;
  var countSeconds = 60.obs;
  var showExpireError = false.obs;
  var showInvalidError = false.obs;

  final AppController auth = Get.find();
  final SmsService smsService = Get.find();

  @override
  void onReady() {
    super.onReady();
    Get.snackbar(
      "¿Te equivocaste de número?",
      "Puedes cambiar tu número precionando en el número que aparece en azul.",
      duration: const Duration(seconds: 10),
    );
    countSeconds.value = 60;
    sendCode(auth.userInfo);
  }

  int generateCode() {
    var rng = Random();
    var code = rng.nextInt(900000) + 100000;
    return code;
  }

  void resendCode(UserModel user) async {
    int _code = await sendSMSCode();
    refCode.value = _code.toString();
    initCounter();
  }

  void sendCode(UserModel user) async {
    int? _code;
    if (user.smsCode.isEmpty) {
      _code = await sendSMSCode();
    } else {
      _code = int.parse(user.smsCode);
    }

    if (_code != null) {
      refCode.value = _code.toString();
    }

    initCounter();
  }

  void initCounter() {
    if (countSeconds > 0) {
      int _counter = countSeconds.value;
      Timer(const Duration(seconds: 1), () {
        _counter--;

        countSeconds.value = _counter;

        return initCounter();
      });
    } else {
      showExpireError.value = false;
    }
  }

  void verifyPhone(String code) async {
    Timestamp expireDate = auth.userInfo.smsCodeExpire;
    showExpireError.value = false;
    showInvalidError.value = false;

    if (code == refCode.value && expireDate.compareTo(Timestamp.now()) == 1) {
      await Firestore.collection('users').doc(auth.userInfo.id)
      .update({
        'sms_code': '0',
        'phone_verified': true,
      });

      auth.checkLocationPermissions();
      return;
    }

    if (code == refCode.value && expireDate.compareTo(Timestamp.now()) == -1) {
      showExpireError.value = true;
      showInvalidError.value = false;
      countSeconds.value = 0;
      return;
    }

    if (code != refCode.value) {
      showExpireError.value = false;
      showInvalidError.value = true;
      return;
    }
  }

  sendSMSCode() async {
    try {
      int code = generateCode();

      await Firestore.collection('users').doc(auth.userInfo.id).update({
        'sms_code': code.toString(),
        'sms_code_expire': DateTime.now().add(const Duration(minutes: 5)),
      });

      int statusCode = await smsService.send(
          auth.userInfo.mobile.split('+')[1],
          '<Plass>Código de verificación: $code. Tu código sera válido por 5 minutos. Protege tu cuenta y no compartas este código.'
      );

      if (statusCode == 200) {
        return code;
      }

      return Get.snackbar('Error de envío', 'Ha ocurrido un error al enviar tu mensáje por favor solicita uno nuevo.');
    } on SocketException catch (_) {
      Get.snackbar('¡Oops!', '¡Su conexión a internet ha fallado!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}