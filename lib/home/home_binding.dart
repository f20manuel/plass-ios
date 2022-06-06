import 'package:get/get.dart';
import 'package:plass/home/home_controller.dart';
import 'package:plass/services/bookings_service.dart';
import 'package:plass/services/car_types_service.dart';
import 'package:plass/services/chats_service.dart';
import 'package:plass/services/drivers_service.dart';
import 'package:plass/services/here_service.dart';
import 'package:plass/services/notifications_service.dart';
import 'package:plass/services/tracking_service.dart';
import 'package:plass/widgets/drawer/drawer_controller.dart';
import 'package:plass/widgets/plass_swipe_button/plass_swipe_button_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HereService());
    Get.lazyPut(() => DriverService());
    Get.lazyPut(() => BookingsService());
    Get.lazyPut(() => CarTypesService());
    Get.lazyPut(() => TrackingService());
    Get.lazyPut(() => ChatsService());
    Get.lazyPut(() => NotificationsService());
    Get.lazyPut(() => PlassSwipeButtonController());
    Get.lazyPut(() => PlassDrawerController());
    Get.lazyPut(() => HomeController());
  }
}