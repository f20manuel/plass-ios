import 'package:get/get.dart';
import 'package:plass/favorites/favorites_controller.dart';
import 'package:plass/services/favorites_service.dart';

class FavoritesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoritesController());
    Get.lazyPut(() => FavoritesService());
  }
}