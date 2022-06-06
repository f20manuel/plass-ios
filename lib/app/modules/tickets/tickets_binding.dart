import 'package:get/get.dart';
import 'package:plass/app/modules/tickets/tickets_controller.dart';

class TicketsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketsController());
  }
}