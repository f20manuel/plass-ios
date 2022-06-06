import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/verify_phone/verify_phone_controller.dart';
import 'package:plass/widgets/change_phone_number/change_phone_binding.dart';
import 'package:plass/widgets/change_phone_number/change_phone_number_widget.dart';

class VerifyPhonePage extends GetView<VerifyPhoneController> {
  const VerifyPhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewPadding;
    return Scaffold(
        body: Obx(() => Container(
          height: Get.height,
          padding: EdgeInsets.only(
            top: padding.top,
            bottom: padding.bottom + 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: 64,
                        bottom: 32
                    ),
                    child: const Image(
                        image: AssetImage('assets/main/PlassLogo.png'),
                        width: 100,
                        fit: BoxFit.contain
                    ),
                  ),
                  Container(
                      width: Get.width - 32,
                      margin: const EdgeInsets.only(
                        top: 16,
                        bottom: 8,
                      ),
                      child: Text(
                          'Verificar teléfono',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: Get.theme.textTheme.headline5!.fontSize,
                              fontWeight: FontWeight.bold
                          )
                      )
                  ),
                  Container(
                      width: Get.width - 32,
                      margin: const EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Revisa tus mensajes de texto. Te enviamos el PIN a ',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              TextSpan(
                                  text: controller.auth.userInfo.mobile,
                                  style: const TextStyle(
                                      color: Palette.primary,
                                      fontWeight: FontWeight.bold
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(() => const ChangePhoneNumber(), binding: ChangePhoneBinding(), fullscreenDialog: true);
                                    }
                              )
                            ]
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PinCodeTextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        controller.code.value = value;
                      },
                      onCompleted: (value) {
                        controller.verifyPhone(value);
                      },
                      length: 6,
                      appContext: Get.context!,
                      pinTheme: PinTheme(
                        borderRadius: BorderRadius.circular(20),
                        shape: PinCodeFieldShape.box,
                        fieldHeight: 49,
                        fieldWidth: 49,
                        inactiveColor: Colors.grey,
                        activeColor: Palette.primary,
                      ),
                    ),
                  ),
                  controller.showExpireError.value
                      ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'El código de verificación ha expirado, por favor solicite otro.',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                      : Container(),
                  controller.showInvalidError.value
                      ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'El código de verificación es incorreto.',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                      : Container(),
                ],
              ),
              SizedBox(
                  width: Get.width - 32,
                  child: ElevatedButton(
                      onPressed: controller.countSeconds.value == 0
                          ? () {
                        controller.countSeconds.value = 60;
                        controller.resendCode(controller.auth.userInfo);
                      } : null,
                      child: Text(
                        controller.countSeconds.value > 0
                          ? 'Reenviar código en ${controller.countSeconds.value}\'s'
                          : 'Reenviar código',
                        style: TextStyle(
                          color: controller.countSeconds.value > 0
                            ? Colors.grey
                            : Colors.white,
                        )
                      )
                  )
              )
            ],
          ),
        )
      )
    );
  }
}