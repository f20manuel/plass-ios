import 'package:get/get.dart';

class PlassSwipeButtonController extends GetxController {
  var left = Rx<double?>(null);
  var right = Rx<double?>(null);
  var active = false.obs;
}