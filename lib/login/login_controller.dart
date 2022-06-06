import 'package:get/get.dart';
import 'package:plass/recovery_password/recovery_password_binding.dart';
import 'package:plass/recovery_password/recovery_password_page.dart';
import 'package:plass/services/auth_service.dart';

class LoginController extends GetxController {
  var loading = false.obs;
  var securePassword = true.obs;

  final AuthService authService = Get.find();

  goToRecoveryPassword() async {
    var result = await Get.to(
      () => const RecoveryPasswordPage(),
      binding: RecoveryPasswordBinding(),
      fullscreenDialog: true,
      transition: Transition.downToUp,
    );

    if (result != null) {
      Get.snackbar("Email de recuperación enviado", "Hemos enviado un mensaje de recuperación a $result.");
    }
  }

  @override
  void onClose() {
    loading.value = false;
    super.onClose();
  }
}