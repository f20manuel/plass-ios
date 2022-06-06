import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/login/login_binding.dart';
import 'package:plass/login/login_page.dart';
import 'package:plass/models/user.dart';
import 'package:plass/register/register_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends GetView<RegisterController> {
  RegisterPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

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
          child: Container(
            padding: const EdgeInsets.only(
              bottom: 16,
              left: 16,
              right: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    'Crea tu cuenta',
                  style: TextStyle(
                    color: Palette.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                  )
                ),
                const Divider(color: Colors.transparent, height: 8),
                Row(
                    children: [
                      const Text(
                          '¿Ya tienes una cuenta? ',
                        style: TextStyle(
                          color: Colors.black54,
                        )
                      ),
                      InkWell(
                          onTap: () => Get.off(() => LoginPage(), binding: LoginBinding()),
                          child: const Text('Iniciar sesión',
                              style: TextStyle(
                                color: Palette.primary,
                              )
                          )
                      )
                    ]
                ),
                Container(
                  margin: const EdgeInsets.only(top: 32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: const Text(
                                          'Nombre',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )
                                      )
                                  ),
                                  TextFormField(
                                    controller: _firstNameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Escribe tu nombre',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Debe ingresar su nombre';
                                      }

                                      return null;
                                    },
                                  ),
                                ],
                              )
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: const Text(
                                          'Apellido',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )
                                      )
                                  ),
                                  TextFormField(
                                    controller: _lastNameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Escribe tus apellidos',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: const Text(
                                          'Email',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )
                                      )
                                  ),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      hintText: 'Escribe tu email',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Debe ingresar su correo electrónico';
                                      }

                                      return null;
                                    },
                                  ),
                                ],
                              )
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: const Text(
                                          'Contraseña',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )
                                      )
                                  ),
                                  Obx(() => TextFormField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      hintText: 'Escribe tu contraseña',
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () => controller.securePassword.toggle(),
                                        icon: Icon(controller.securePassword.isTrue ? Icons.visibility : Icons.visibility_off),
                                      ),
                                    ),
                                    obscureText: controller.securePassword.value,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Debe ingresar su contraseña';
                                      }

                                      return null;
                                    },
                                  )),
                                ],
                              )
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Teléfono',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )
                                ),
                                Obx(() => Container(
                                  margin: const EdgeInsets.only(top: 8.0),
                                  height: 59,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(
                                        width: controller.phoneBorderWidth.value,
                                        color: controller.phoneBorderColor.value,
                                      )
                                  ),
                                  child: Row(
                                      children: [
                                        CountryCodePicker(
                                          onChanged: print,
                                          initialSelection: '+57',
                                          favorite: const ['+57'],
                                          countryFilter: const ['+57'],
                                          showFlagDialog: true,
                                          onInit: (code) => {},
                                          flagDecoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                        Container(
                                          height: 30.0,
                                          width: 1.0,
                                          color: Colors.grey,
                                          margin: const EdgeInsets.only(
                                              left: 8.0, right: 8.0
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.5,
                                            child: Focus(
                                                onFocusChange: (hasFocus) {
                                                  controller.phoneBorderWidth.value = hasFocus
                                                      ? 2.0 : 1.0;
                                                  controller.phoneBorderColor.value = hasFocus
                                                      ? Palette.primary
                                                      : Colors.grey;
                                                },
                                                child: TextFormField(
                                                  controller: _phoneController,
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(10),
                                                  ],
                                                  keyboardType: TextInputType.phone,
                                                  decoration: const InputDecoration(
                                                      hintText: '3001234567',
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            width: 0,
                                                            color: Colors.transparent,
                                                          )
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            width: 0,
                                                            color: Colors.transparent,
                                                          )
                                                      )
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Debe ingresar su numero de teléfono';
                                                    }

                                                    return null;
                                                  },
                                                )
                                            )
                                        )
                                      ]
                                  ),
                                ))
                              ]
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                            child: const Text(
                                'Género',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 59,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(16.0)
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Center(
                                child: Obx(() => DropdownButton(
                                  value: controller.gender.value.toString(),
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  isExpanded: true,
                                  underline: Container(
                                    height: 0,
                                  ),
                                  onChanged: (String? newValue) {
                                    switch(newValue) {
                                      case 'Gender.female':
                                        controller.gender.value = Gender.female;
                                        break;
                                      default: controller.gender.value = Gender.male;
                                    }
                                  },
                                  items: <String>['Gender.male', 'Gender.female']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                          value == 'Gender.male' ?
                                          'Masculino' : 'Femenino'
                                      ),
                                    );
                                  }).toList(),
                                ),
                                )),
                          ),
                          controller.args != null
                          ? Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                                  child: const Text(
                                      'Referido',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                      horizontal: 12,
                                    ),
                                    width: Get.width - 32,
                                    height: 59,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16.0),
                                        border: Border.all(
                                          width: controller.phoneBorderWidth.value,
                                          color: controller.phoneBorderColor.value,
                                        )
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                            Icons.qr_code_rounded,
                                            color: Colors.black54
                                        ),
                                        const VerticalDivider(color: Colors.transparent),
                                        Text(
                                            "${controller.args!.referred.firstName} ${controller.args!.referred.lastName ?? ""}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54
                                            )
                                        )
                                      ],
                                    )
                                )
                              ],
                            )
                          : Container(),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(top: 32.0),
                              child: Row(
                                  children: [
                                    Obx(() => Checkbox(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        fillColor: MaterialStateProperty.all(Palette.primary),
                                        value: controller.acceptedTerms.value,
                                        onChanged: (value) {
                                          controller.acceptedTerms.value = value!;
                                        })
                                    ),
                                    Flexible(
                                      child: RichText(
                                          text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Al crear una cuenta, aceptas que has leído y aceptado nuestros ',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                                TextSpan(
                                                  text: 'Términos y condiciones',
                                                  style: const TextStyle(color: Colors.blue),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () { launch(
                                                      'https://plass.app/terminos-y-condiciones-usuario',
                                                    );
                                                    },
                                                ),
                                                const TextSpan(
                                                  text: ' y nuestra ',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                                TextSpan(
                                                  text: 'Políticas de privacidad',
                                                  style: const TextStyle(color: Colors.blue),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () { launch(
                                                      'https://plass.app/politicas-de-privacidad',
                                                    );
                                                    },
                                                ),
                                              ]
                                          )
                                      ),
                                    )
                                  ]
                              )
                          ),
                          Obx(() => Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                              top: 32.0,
                              bottom: MediaQuery.of(context).viewPadding.bottom,
                            ),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty
                                    .all<Color>(Colors.white),
                                shape: MaterialStateProperty
                                    .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    )
                                ),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(16.0)
                                ),
                              ),
                              onPressed: controller.acceptedTerms.isTrue ? () {
                                if (_formKey.currentState!.validate()) {
                                  controller.register(
                                    _firstNameController.text,
                                    _lastNameController.text,
                                    _emailController.text,
                                    _phoneController.text,
                                    _passwordController.text,
                                    controller.gender.value,
                                  );
                                }

                                return;
                              } : null,
                              child: controller.loadingRegister.isTrue
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                'Regístrate',
                                style: TextStyle(
                                  fontSize: 18.0,
                                )
                              ),
                            ),
                          )),
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}