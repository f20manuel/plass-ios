import 'package:get/get.dart';
import 'package:plass/help/last_trip_problem/last_trip_problem_controller.dart';
import 'package:plass/services/help/last_trip_problem_service.dart';

class LastTripProblemBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LastTripProblemService());
    Get.lazyPut(() => LastTripProblemController());
  }
}