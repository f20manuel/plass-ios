import 'package:get/get.dart';
import 'package:plass/help/others/others_problems/others_problems_controller.dart';

class OthersProblemsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OthersProblemsController());
  }
}