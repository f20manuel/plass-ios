import 'package:get/get.dart';
import 'package:plass/search_booking/search_controller.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchController());
  }
}