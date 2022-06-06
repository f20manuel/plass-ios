import 'package:get/get.dart';
import 'package:plass/help/account_problem/my_account_problem/my_account_problem_controller.dart';

class MyAccountProblemBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyAccountProblemController());
  }
}