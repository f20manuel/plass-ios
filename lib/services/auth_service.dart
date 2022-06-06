import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/user.dart';
import 'package:plass/register/register_controller.dart';
import 'package:plass/services/users_service.dart';

class AuthService extends GetxService {
  final auth = FirebaseAuth.instance;
  final UsersService usersService = Get.find();

  Future<void> signIn(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
    } on FirebaseAuthException catch (exception) {
      switch(exception.code) {
        case "wrong-password":
          Get.snackbar("¡Contraseña incorrecta!", "Si olvido su contraseña puede precionar en \"Recuperar contraseña\".");
          break;
        case "too-many-requests":
          Get.snackbar("¡Muchos intentos!", "Su cuenta ha sido bloqueada por muchos intentos, intenteló más tarde.");
          break;
        case "user-not-found":
          Get.snackbar("Usuario no encontrado", "El usuario $email no se encuentra registrado en nuestra base de datos");
          break;
        default: Get.snackbar(exception.code, exception.message.toString());
      }
    }
  }

  Future<void> signInWithCredential(AuthCredential credential) async {
    await auth.signInWithCredential(credential);
  }

  Future<void> logout() async {
    await usersService.updateAuth({
      "fcm_tokens": []
    });
    await auth.signOut();
  }

  Future<void>  register(String firstName, lastName, email, phone, password, Gender gender, RegisterArguments? args) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Map<String, dynamic> newData = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'mobile': '+57$phone',
        'gender': gender.toString(),
        'home': <String, dynamic>{},
        'job': <String, dynamic>{},
        'phone_verified': false,
        'coupons': [],
        'fcm_tokens': [],
        'avatar': '',
        'user_type': 'rider',
        'rate': '0.0',
        'device_os': 'ios',
        'sms_code': '',
        'sms_code_expire': Timestamp.now(),
        'settings': <String, dynamic>{
          'notifications': <String, dynamic>{
            'email': true,
            'sms': true,
          }
        },
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      };

      if (args != null) {
        newData['referred'] = args.referred.id;
      }

      if (userCredential.user != null) {
        await Firestore.collection('user_payment_methods').add({
          'user_uid': userCredential.user!.uid,
          'currency': 'COP\$',
          'name': 'Efectivo',
          'image': 'attach_money',
          'image_type': 'icon',
          'status': true,
        });

        await Firestore.collection('users').doc(userCredential.user!.uid)
            .set(newData)
            .then((value) {
          auth.signInWithCredential(userCredential.credential!);
        });
      }
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
    } on FirebaseAuthException catch (exception) {
      switch(exception.code) {
        case "email-already-in-use":
          Get.snackbar("Correo existente", "El correo $email, ya se encuentra en uso");
          break;
        case "invalid-email":
          Get.snackbar("Correo inválido", "¡Debe ingresar una dirección de correo electrónico correcta!");
          break;
        case "weak-password":
          Get.snackbar("Contraseña corta", "Su contraseña debe tener por lo menos 6 caráteres");
          break;
        default: Firestore.generateLog(exception, "in register function in lib/services/auth_service.dart");
      }
    } on FirebaseException catch (exception) {
      Firestore.generateLog(exception, "in register function in lib/services/auth_service.dart");
    } catch (exception) {
      Firestore.generateLog(exception, "in register function in lib/services/auth_service.dart");
    }
  }
}