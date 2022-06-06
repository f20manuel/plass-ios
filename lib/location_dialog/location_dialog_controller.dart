import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/home/home_binding.dart';
import 'package:plass/home/home_page.dart';

class LocationDialogController extends GetxController {
  final location = Location.instance;

  final AppController app = Get.find();
  final auth = FirebaseAuth.instance;

  checkPermissions() async {
    PermissionStatus permission = await location.requestPermission();

    if (permission == PermissionStatus.deniedForever || permission == PermissionStatus.denied) {
      Get.snackbar(
        'Ubicación negada',
        'Si no nos otorgas los permisos de ubicación, no podrás usar nuestro servicios al 100%.'
      );
    }

    Get.offAll(() => HomePage(), binding: HomeBinding());
  }

  requestLocationPermissions() async {
    //location.changeSettings(accuracy: LocationAccuracy.low);

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    checkPermissions();
  }
}