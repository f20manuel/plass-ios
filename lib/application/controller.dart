import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:plass/auth/auth_page.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/home/home_binding.dart';
import 'package:plass/home/home_controller.dart';
import 'package:plass/location_dialog/location_dialog_binding.dart';
import 'package:plass/location_dialog/location_dialog_page.dart';
import 'package:plass/models/user.dart';
import 'package:plass/services/auth_service.dart';
import 'package:plass/services/users_service.dart';
import 'package:plass/verify_phone/verify_phone_binding.dart';
import 'package:plass/verify_phone/verify_phone_page.dart';

import '../home/home_page.dart';

class AppController extends SuperController {
  late Rx<User?> authUser;
  late Rx<UserModel> firestoreUser;
  var connectivityResult = ConnectivityResult.none.obs;
  UserModel get userInfo => firestoreUser.value;

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final location = Location.instance;
  final UsersService usersService = Get.find();
  final AuthService authService = Get.find();

  // StreamSubscriptions
  late StreamSubscription? connectivitySubscription;

  // instances
  final connectivity = Connectivity();

  @override
  void onInit() {
    initConnectivity();
    connectivitySubscription = connectivity.onConnectivityChanged.listen(handleConnectivity);
    super.onInit();
  }

  @override
  void onReady() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.onReady();
    authUser = Rx<User?>(auth.currentUser);
    authUser.bindStream(auth.userChanges());
    ever(authUser, handleAuth);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      Firestore.generateLog(e, 'Couldn\'t check connectivity status');
      return;
    }

    connectivityResult.value = result;
  }

  handleAuth(User? user) {
    if (user == null) {
      Get.offAll(() => const AuthPage());
    } else {
      Firestore.collection('users')
      .doc(auth.currentUser!.uid)
      .get()
      .then((document) {
        UserModel model = UserModel.fromDocumentSnapshot(document);
        if (model.softDelete != null) {
          if (model.softDelete!.compareTo(Timestamp.now()) == 1) {
            Get.snackbar(
              '¡Bienvenid@, ${model.firstName}!',
              'Que gusto tenerte de vuelta.',
              duration: const Duration(seconds: 5)
            );
            usersService.updateAuth({
              'soft_delete': null,
            });
          } else {
            authService.logout();
            return;
          }
        }
        firestoreUser = Rx<UserModel>(model);
        firestoreUser.bindStream(usersService.streamByUid(auth.currentUser!.uid));
        checkPhoneValidation(auth.currentUser!.uid);
      })
      .catchError((exception) {
        Get.snackbar("Error", exception.toString());
        Firestore.generateLog(exception, "Function handleAuth in lib/application/controller.dart");
        authService.logout();
      });
    }
  }

  handleConnectivity(ConnectivityResult result) {
    connectivityResult.value = result;
  }

  checkPhoneValidation(String uid) async {
    try {
      UserModel _user = UserModel.fromDocumentSnapshot(
        await Firestore.collection('users').doc(uid).get()
      );

      if (_user.mobileVerified) {
        checkLocationPermissions();
        return;
      }

      Get.offAll(() => const VerifyPhonePage(), binding: VerifyPhoneBinding());
    } on SocketException catch (_) {
      Get.snackbar('¡Oops!', '¡Su conexión a internet ha fallado!');
    } on FirebaseException catch (e) {
      Get.snackbar(e.code, e.message.toString());
    }
  }

  checkLocationPermissions() async {
    try {
      PermissionStatus permission = await location.hasPermission();

      if (permission == PermissionStatus.granted) {
        Get.offAll(() => HomePage(), binding: HomeBinding());
        return;
      } else if (permission == PermissionStatus.deniedForever) {
        Get.offAll(() => HomePage(), binding: HomeBinding());
        return;
      } else {
        await Get.to(() => const LocationDialogPage(), binding: LocationDialogBinding());
        Get.reload();
        onReady();
      }
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
    } catch (e) {
      Firestore.generateLog(e, 'Line 75 in lib/application/controller.dart');
    }
  }

  @override
  void onClose() {
    connectivitySubscription?.cancel();
    super.onClose();
  }

  @override
  void onDetached() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.appUpdate();
  }

  @override
  void onInactive() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.appUpdate();
  }

  @override
  void onPaused() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.appUpdate();
  }

  @override
  void onResumed() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.appUpdate();
  }
}