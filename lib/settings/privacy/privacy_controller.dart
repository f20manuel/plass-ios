import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/models/user.dart';
import 'package:plass/services/users_service.dart';

class PrivacyController extends GetxController {
  final auth = FirebaseAuth.instance;

  //services
  final UsersService usersService = Get.find();

  //controllers
  final AppController app = Get.find();

  changeNotificationsSettings(UserSettings settings) async {
    await usersService.updateAuth({
      'settings': settings.toJson()
    });
  }
}