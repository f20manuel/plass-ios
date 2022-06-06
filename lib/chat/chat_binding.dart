import 'package:get/get.dart';
import 'package:plass/chat/chat_controller.dart';
import 'package:plass/services/chat_service.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatService());
    Get.lazyPut(() => ChatController());
  }
}