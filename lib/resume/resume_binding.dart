import 'package:get/get.dart';
import 'package:plass/resume/resume_controller.dart';
import 'package:plass/services/bookings_service.dart';

class ResumeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookingsService());
    Get.lazyPut(() => ResumeController());
  }
}