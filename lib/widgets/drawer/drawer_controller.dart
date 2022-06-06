import 'package:get/get.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/services/auth_service.dart';

class PlassDrawerController extends GetxController {
  final AppController auth = Get.find();
  final AuthService authService = Get.find();
}