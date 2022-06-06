import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/login/login_binding.dart';
import 'package:plass/login/login_page.dart';
import 'package:plass/qr_code/qr_code_binding.dart';
import 'package:plass/qr_code/qr_code_page.dart';
import 'package:plass/register/register_binding.dart';
import 'package:plass/register/register_page.dart';
import 'package:skeletons/skeletons.dart';

class AuthPage extends GetView<AppController> {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final window = MediaQuery.of(context);
    return Scaffold(
        body: Container(
            width: window.size.width,
            height: window.size.height,
            padding: EdgeInsets.only(
              top: window.padding.top + 16,
              bottom: window.padding.bottom + 16,
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: window.size.height / 4),
                      child: const Image(
                        image: AssetImage('assets/main/PlassLogo.png'),
                        width: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Divider(color: Colors.transparent),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(
                            'v${snapshot.data!.version}',
                            style: const TextStyle(
                              color: Colors.grey,
                            )
                          );
                        }

                        return const SkeletonLine();
                      }
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ))
                      ),
                      onPressed: () => Get.to(RegisterPage(), binding: RegisterBinding()),
                      child: const Text('Regístrate')
                    ),
                    const VerticalDivider(color: Colors.transparent),
                    MaterialButton(
                      color: Colors.white,
                      elevation: 3,
                      minWidth: 50,
                      height: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        side: const BorderSide(
                          width: 2,
                          color: Palette.secondary,
                        )
                      ),
                      padding: const EdgeInsets.all(8.0),
                      onPressed: () => Get.to(
                        () => const QrCodePage(), binding: QrCodeBinding(),
                        fullscreenDialog: true,
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        color: Palette.secondary
                      )
                    ),
                    const VerticalDivider(color: Colors.transparent),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Palette.secondary),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ))
                        ),
                        onPressed: () => Get.to(LoginPage(), binding: LoginBinding()),
                        child: const Text('Iniciar sesión')
                    ),
                  ]
                )
              ],
            )
        )
    );
  }
}
