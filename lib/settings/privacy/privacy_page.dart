import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/models/user.dart';
import 'package:plass/settings/privacy/privacy_controller.dart';

class PrivacyPage extends GetView<PrivacyController> {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Privacidad')
      ),
      body: Obx(() => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: const Text(
                      'Descuentos y notificaciones',
                      textAlign: TextAlign.left,
                    )
                  ),
                  ListTile(
                    title: const Text('SMS'),
                    trailing: Switch(
                      value: controller.app.userInfo.settings.notifications.sms,
                      onChanged: (value) async {
                        UserSettings settings = UserSettings(
                            notifications: UserNotification(
                                email: controller.app.userInfo.settings
                                    .notifications.email,
                                sms: value
                            )
                        );

                        if (value) {
                          controller.changeNotificationsSettings(settings);
                        } else {
                          var result = await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return notificationsModal(context);
                            }
                          );

                          if (result != null) {
                            controller.changeNotificationsSettings(settings);
                          }
                        }
                      }),
                    ),
                  ListTile(
                    title: const Text('Correo electrónico'),
                    trailing: Switch(
                      value: controller.app.userInfo.settings.notifications.email,
                      onChanged: (value) async {
                        UserSettings settings = UserSettings(
                            notifications: UserNotification(
                                sms: controller.app.userInfo.settings
                                    .notifications.sms,
                                email: value
                            )
                        );

                        if (value) {
                          controller.changeNotificationsSettings(settings);
                        } else {
                          var result = await showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return notificationsModal(context);
                              }
                          );

                          if (result != null) {
                            controller.changeNotificationsSettings(settings);
                          }
                        }
                      }),
                    ),
                ],
              )
            )
          ],
        ),
      ))
    );
  }

  Widget notificationsModal(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: Get.height * 0.3 +
          MediaQuery.of(context).viewPadding.bottom,
      child: Material(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: const [
                    Text(
                        '¿Deseas desactivar las notificaciones y promociones?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    Text(
                      'No recibirás notificaciones sobre ofertas, descuentos y otros eventos',
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 8,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                foregroundColor: MaterialStateProperty.all(Palette.primary),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(
                                        width: 1,
                                        color: Palette.primary
                                    )
                                ))
                            ),
                            onPressed: () => Get.back(),
                            child: const Text('Cancelar')
                        ),
                      ),
                      SizedBox(
                        width: Get.width / 2 - 8,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                            ),
                            onPressed: () => Get.back(result: true),
                            child: const Text('Desactivar')
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}