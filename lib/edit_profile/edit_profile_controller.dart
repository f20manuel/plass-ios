import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/services/users_service.dart';

class EditProfileController extends GetxController {
  var loadingStorage = false.obs;
  var avatar = Rx<Widget?>(null);

  //services
  final UsersService usersService = Get.find();

  //controllers
  final AppController app = Get.find();

  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final imagePicker = ImagePicker();
  final _cropImage = ImageCropper();

  @override
  void onInit() {
    super.onInit();
    avatar = Rx<Widget?>(ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image(
        image: NetworkImage(
            app.userInfo.avatar.isNotEmpty
                ? app.userInfo.avatar
                : PlassConstants.defaultAvatar
        ),
      ),
    ));
    firstNameController.value.text = app.userInfo.firstName;
    lastNameController.value.text = app.userInfo.lastName ?? '';
  }

  void pickImage(ImageSource source) async {
    XFile? image = await imagePicker.pickImage(source: source);

    if (image != null) {
      // cropImage(context, image);
      cropImage(image);
      return;
    }
    loadingStorage.value = false;
  }

  void cropImage(XFile? image) async {
    try {
      File? croppedFile = await _cropImage.cropImage(
        sourcePath: image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        iosUiSettings: const IOSUiSettings(
          title: 'PLASS: Foto de perfil',
        )
      );

      if (croppedFile != null) {
        avatar = Rx<Widget?>(ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.file(
            croppedFile,
            width: 64,
            height: 64,
            fit: BoxFit.contain,
          ),
        ));

        uploadImageToFirebase(croppedFile);
      }
    } catch (exception) {
      Firestore.generateLog(exception, "cropImage function in lib/edit_profile/edit_profile_controller.dart");
    }
  }

  void uploadImageToFirebase(File? image) {
    FirebaseStorage.instance
      .ref('users/avatars/${app.userInfo.id}/')
      .putFile(image as File)
      .then((storage) {
      storage.ref.getDownloadURL().then((url) {
        usersService.updateAuth({
          'avatar': url.toString(),
        }).then((_) {
          loadingStorage.value = false;

          Get.defaultDialog(
            title: '¡Foto Actualizada!',
            content: const Text(
              'Se ha actualizado tu foto de perfil con éxito'
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Aceptar')
              )
            ]
          );
        }).catchError((e) => throw Exception(e));
      }).catchError((e) => throw Exception(e));
    }).catchError((e) => throw Exception(e));
  }

  void exit() async {
    if (
      firstNameController.value.text != app.userInfo.firstName ||
      lastNameController.value.text != app.userInfo.lastName
    ) {
      try {
        await usersService.updateAuth({
          'first_name': firstNameController.value.text,
          'last_name': lastNameController.value.text,
        });

        Get.back();
      } on FirebaseException catch (exception) {
        Firestore.generateLog(exception, "Exit function in lib/edit_profile/edit_profile_controller.dart");
      }
    } else {
      Get.back();
    }
  }
}