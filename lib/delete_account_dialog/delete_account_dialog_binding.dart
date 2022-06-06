import 'package:get/get.dart';
import 'package:plass/delete_account_dialog/delete_account_dialog_controller.dart';

class DeleteAccountDialogBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeleteAccountDialogController());
  }
}