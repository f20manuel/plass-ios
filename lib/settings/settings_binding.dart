import 'package:get/get.dart';
import 'package:plass/notifications_dialog/notifications_dialog_controller.dart';
import 'package:plass/settings/settings_controller.dart';

class SettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationsDialogController());
    Get.lazyPut(() => SettingsController());
  }
}