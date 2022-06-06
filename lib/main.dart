import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:here_sdk/core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plass/application/binding.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/environment.dart';
import 'package:plass/firebase_options.dart';
import 'package:skeletons/skeletons.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.pro,
  );

  Environment().initConfig(environment);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.ios,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SdkContext.init(IsolateOrigin.main);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: Environment().config.version == "DEV",
      theme: ThemeData(
        primarySwatch: Palette.primary,
      ),
      home: const Home(),
    );
  }
}

class Home extends GetView<AppController> {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
          children: [
            SizedBox(
              width: Get.width,
              height: Get.height,
              child: Image(
                image: const AssetImage('assets/main/PlassLogo.png'),
                width: Get.width - 32,
              ),
            ),
            Positioned(
                top: Get.height / 3.75,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: Get.width - 64,
                    height: Get.width - 64,
                    child: const CircularProgressIndicator(
                      strokeWidth: 8,
                      color: Colors.amber,
                    ),
                  ),
                )
            ),
            Positioned(
                bottom: Get.bottomBarHeight + 16,
                left: 0,
                right: 0,
                child: Center(
                    child: FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SkeletonLine(
                                style: SkeletonLineStyle(
                                  width: 64,
                                  height: 16,
                                )
                            );
                          }

                          return Text(
                              snapshot.data!.version,
                              style: const TextStyle(
                                  color: Colors.black54
                              )
                          );
                        }
                    )
                )
            )
          ]
      ),
    );
  }

}
