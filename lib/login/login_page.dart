import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/login/login_controller.dart';
import 'package:plass/register/register_binding.dart';
import 'package:plass/register/register_page.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({Key? key}) : super(key: key);
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: MediaQuery.of(context).size.height - 100,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bienvenido',
                    style: TextStyle(
                      color: Palette.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    )
                  ),
                  const Divider(color: Colors.transparent, height: 8),
                  Row(
                    children: const [
                      Text(
                        'Inicia sesión en tu cuenta',
                        style: TextStyle(
                          color: Colors.black54,
                        )
                      ),
                    ]
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 32.0),
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                  'Correo electrónico',
                                  style:TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    hintText: 'Escribe tu correo electrónico',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese su correo electrónico';
                                    }

                                    if (!GetUtils.isEmail(value)) {
                                      return 'Por favor ingrese un correo electrónico válido';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ]
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Contraseña',
                                style:TextStyle(
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Obx(() => TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    hintText: 'Escribe tu contraseña',
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        controller.securePassword.toggle();
                                      },
                                      icon: Icon(
                                          controller.securePassword.isTrue
                                              ? Icons.visibility
                                              : Icons.visibility_off
                                      ),
                                    ),
                                  ),
                                  obscureText: controller.securePassword.isTrue,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese su contraseña';
                                    }

                                    return null;
                                  },
                                ),
                                ),
                              ),
                            ]
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: controller.goToRecoveryPassword,
                            child: const Text('Recuperar contraseña')
                          )
                        ]
                      ),
                      const Divider(color: Colors.transparent),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                              shape:
                              MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  )),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(16.0)),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                controller.loading.value = true;
                                controller.authService.signIn(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                                Timer(const Duration(milliseconds: 500), () {
                                  controller.loading.value = false;
                                });
                              }
                            },
                            child: Obx(() {
                              if (controller.loading.isTrue) {
                                return const SizedBox(
                                  width: 16.0,
                                  height: 16.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: Colors.white,
                                  ),
                                );
                              }

                              return const Text('Iniciar Sesión',
                                style: TextStyle(
                                  fontSize: 18.0,
                                )
                              );
                            })
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            bottom: MediaQuery.of(context).viewPadding.bottom,
            right: 0.0,
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿No tienes cuenta? '),
                InkWell(
                  onTap: () => Get.off(RegisterPage(), binding: RegisterBinding()),
                  child: const Text(
                    'Registrarte',
                    style: TextStyle(
                      color: Palette.primary,
                    ),
                  ),
                )
              ]
            )
          )
        ])
      )
    );
  }

}