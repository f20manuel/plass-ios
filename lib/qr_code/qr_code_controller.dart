import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/register/register_binding.dart';
import 'package:plass/register/register_page.dart';
import 'package:plass/services/drivers_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../models/driver.dart';
import '../register/register_controller.dart';

class QrCodeController extends GetxController {
  var result = Rx<Barcode?>(null);
  var qrController = Rx<QRViewController?>(null);

  // controllers
  final AppController app = Get.find();
  final RegisterController registerController = Get.find();

  // services
  final DriverService driverService = Get.find();

  void onScan(Barcode scan) async {
    try {
      if (app.connectivityResult.value == ConnectivityResult.none) return PlassConstants.notNetworkMessage();

      DriverModel? driverModel = await driverService.getModel(scan.code.toString());

      if (driverModel != null) {
        Get.off(
          () => RegisterPage(),
          binding: RegisterBinding(),
          arguments: RegisterArguments(referred: driverModel),
        );
      }
    } on SocketException catch(_) {
      PlassConstants.notNetworkMessage();
    } on FirebaseException catch (exception) {
      Firestore.generateLog(exception, "Function on Scan -> lib/qr_code/qr_code_controller.dart");
    }
  }
}