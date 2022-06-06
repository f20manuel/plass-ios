import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/recovery_password/recovery_password_controller.dart';

class RecoveryPasswordPage extends GetView<RecoveryPasswordController> {
  const RecoveryPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage('assets/main/foreground-icon.png'),
                width: Get.width - 64,
                height: 100,
                fit: BoxFit.cover,
              ),
              const Divider(color: Colors.transparent),
              const Text(
                'Recuperar Contraseña',
                style: TextStyle(
                  color: Palette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )
              ),
              const Divider(color: Colors.transparent),
              SizedBox(
                width: Get.width -64,
                child: const Text(
                  'Escriba su correo electrónico‚ para\nrecuperar su contraseña.',
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(color: Colors.transparent),
              SizedBox(
                width: Get.width -64,
                child: TextFormField(
                  controller: controller.emailController.value,
                  decoration: InputDecoration(
                    hintText: 'Correo electrónico',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                  ),
                  onChanged: (value) => controller.email.value = value,
                ),
              ),
              const Divider(color: Colors.transparent),
              SizedBox(
                width: Get.width -64,
                height: 54,
                child: Obx(() => ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ))
                    ),
                    onPressed: controller.email.value.isNotEmpty
                    ? () {
                        FocusScope.of(context).unfocus();
                        Timer(const Duration(milliseconds: 300), () {
                          controller.recovery();
                        });
                      }
                    : null,
                  child: const Text('Continuar')
                ))
              ),
            ],
          )
        ),
      )
    );
  }
}
