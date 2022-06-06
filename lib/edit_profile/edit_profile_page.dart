import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plass/constants.dart';
import 'package:plass/delete_account_dialog/delete_account_dialog_binding.dart';
import 'package:plass/delete_account_dialog/delete_account_dialog_page.dart';
import 'package:plass/edit_profile/edit_profile_controller.dart';
import 'package:plass/models/driver.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                Timer(MediaQuery.of(context).viewInsets.bottom > 0
                ? const Duration(milliseconds: 500)
                : Duration.zero, () =>
                  controller.exit()
                );
              },
              icon: const Icon(Icons.close_rounded
              ),
            ),
            title: const Text('Mi Perfil')
        ),
        body: SingleChildScrollView(
            child: Column(children: [
              Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  child: Material(
                      elevation: 1,
                      child: Container(
                          width: Get.width,
                          color: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(children: [
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                        width: Get.width,
                                        height: 236,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                            )
                                        ),
                                        child: Column(children: [
                                          Container(
                                              width: 60.0,
                                              height: 4.0,
                                              margin: const EdgeInsets.only(
                                                  top: 8.0, bottom: 32.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                BorderRadius.circular(100.0),
                                              )
                                          ),
                                          SizedBox(
                                            width: Get.width,
                                            child: TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                  controller.loadingStorage.value = true;
                                                  controller.pickImage(ImageSource.camera);
                                                },
                                                child: const Text('Cámara')
                                            ),
                                          ),
                                          const Divider(),
                                          SizedBox(
                                            width: Get.width,
                                            child: TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                  controller.loadingStorage.value = true;
                                                  controller.pickImage(ImageSource.gallery);
                                                },
                                                child: const Text('Galería')
                                            ),
                                          ),
                                          const Divider(),
                                          SizedBox(
                                            width: Get.width,
                                            child: TextButton(
                                                onPressed: () => Get.back(),
                                                child: const Text('Cancelar')),
                                          ),
                                        ]
                                        )
                                    );
                                  }
                                );
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() => SizedBox(
                                        width: 64,
                                        height: 64,
                                        child: controller.loadingStorage.isTrue
                                            ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                controller.app.userInfo.avatar.isNotEmpty
                                                    ? controller.app.userInfo.avatar
                                                    : PlassConstants.defaultAvatar
                                            ),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black45,
                                                  borderRadius: BorderRadius.circular(100.0),
                                                ),
                                                child: const Center(
                                                  child: CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                )
                                            )
                                        )
                                            : controller.avatar.value
                                    )
                                    ),
                                    Row(children: const [
                                      Text('Cambiar mi foto',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 92, 89, 89),
                                            fontSize: 18,
                                          )
                                      ),
                                      Icon(
                                        Icons.chevron_right_outlined,
                                        color: Colors.grey,
                                      )
                                    ])
                                  ]),
                            ),
                            const Divider(height: 1.0),
                            TextFormField(
                              controller: controller.firstNameController.value,
                              decoration: const InputDecoration(
                                labelText: 'Nombre',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Ingresa tu nombre por favor';
                                }

                                return null;
                              },
                            ),
                            TextFormField(
                              controller: controller.lastNameController.value,
                              decoration: const InputDecoration(
                                labelText: 'Apellido',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Ingresa tu apellido por favor';
                                }

                                return null;
                              },
                            ),
                            TextFormField(
                              initialValue: controller.app.userInfo.email,
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: 'Correo electrónico',
                              ),
                            ),
                            TextFormField(
                              initialValue: controller.app.userInfo.mobile,
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: 'Teléfono',
                              ),
                            ),
                            Obx(() {
                              if (controller.app.userInfo.referred != null) {
                                return FutureBuilder<DriverModel?>(
                                  future: controller.app.userInfo.getReferred(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      return TextFormField(
                                        initialValue: '${snapshot.data?.firstName ?? ''} ${snapshot.data?.lastName ?? ''}',
                                        enabled: false,
                                        decoration: const InputDecoration(
                                          labelText: 'Referido por',
                                        ),
                                      );
                                    }

                                    return Container();
                                  }
                                );
                              }

                              return Container();
                            })
                          ])
                      )
                  )
              ),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Material(
                    elevation: 1,
                    child: Container(
                        width: Get.width,
                        color: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () => Get.to(
                                () => const DeleteAccountDialogPage(),
                                binding: DeleteAccountDialogBinding()
                              ),
                              title: const Text('Eliminar mi cuenta'),
                              trailing: const Icon(Icons.chevron_right_outlined),
                            )
                          ],
                        )
                    )
                ),
              )
            ])
        )
    );
  }
}