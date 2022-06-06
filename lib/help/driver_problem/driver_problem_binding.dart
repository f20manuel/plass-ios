import 'package:get/get.dart';
import 'package:plass/help/driver_problem/driver_problem_controller.dart';
import 'package:plass/services/help/driver_problem_service.dart';

class DriverProblemBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DriverProblemService());
    Get.lazyPut(() => DriverProblemController());
  }
}