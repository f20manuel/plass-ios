import 'package:get/get.dart';
import 'package:plass/help/driver_problem/vehicle_problem/vehicle_problem_controller.dart';

class VehicleProblemBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VehicleProblemController());
  }
}