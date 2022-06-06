import 'package:get/get.dart';
import 'package:plass/my_trips/my_trips_controller.dart';
import 'package:plass/services/bookings_service.dart';

class MyTripsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookingsService());
    Get.lazyPut(() => MyTripsController());
  }
}