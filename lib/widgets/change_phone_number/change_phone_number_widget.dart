import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/widgets/change_phone_number/change_phone_controller.dart';

class ChangePhoneNumber extends GetView<ChangePhoneNumberController> {
  const ChangePhoneNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
            children: [
              const Text(
                  'Editar número de telefono',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                  )
              ),
              Container(
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
                          child: Material(
                            color: Colors.transparent,
                            child: TextFormField(
                              initialValue: controller.auth.userInfo.mobile.split('+57')[1],
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  hintText: '3001234567',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none
                                  )
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Debe ingresar su numero de teléfono';
                                  }

                                  return null;
                                },
                                onChanged: controller.onChangeNumber
                              ),
                            )
                        )
                      )
                    ]
                ),
              ),
              Obx(() => Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  onPressed: controller.mobile.value != controller.auth.userInfo.mobile &&
                      controller.mobile.value.length > 12
                    ? controller.changeNumber
                    : null,
                  child: const Text('Cambiar', style: TextStyle(color: Colors.white))
                )
              ))
            ]
        )
      )
    );
  }
}
