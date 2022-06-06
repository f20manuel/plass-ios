import 'package:get/get.dart';
import 'package:plass/services/notifications_service.dart';

class NotificationsDialogController extends GetxController {
  final NotificationsService service = Get.find();

  requestPermissions() async {
    await service.requestPermissions();
    Get.back();
  }
}