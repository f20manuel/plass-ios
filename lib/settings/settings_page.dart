import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/constants.dart';
import 'package:plass/settings/new_place/new_place_binding.dart';
import 'package:plass/settings/new_place/new_place_controller.dart';
import 'package:plass/settings/new_place/new_place_page.dart';
import 'package:plass/settings/privacy/privacy_binding.dart';
import 'package:plass/settings/privacy/privacy_page.dart';
import 'package:plass/settings/settings_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../notifications_dialog/notifications_dialog_binding.dart';
import '../notifications_dialog/notifications_dialog_page.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                foregroundImage: NetworkImage(
                  controller.app.userInfo.avatar.isNotEmpty
                  ? controller.app.userInfo.avatar
                  : PlassConstants.defaultAvatar
                ),
              ),
            ),
            Text(
              '${controller.app.userInfo.firstName} ${controller.app.userInfo.lastName ?? ''}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FAVORITOS',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              )
            ),
            Column(
              children: [
                ListTile(
                  title: Text(
                    controller.app.userInfo.home != null
                    ? controller.app.userInfo.home!.title
                    : 'Agregar Casa'
                  ),
                  leading: const Icon(
                    Icons.home_outlined,
                    color: Palette.primary,
                  ),
                  onTap: () {
                    Get.to(
                      () => const NewPlacePage(),
                      binding: NewPlaceBinding(),
                      arguments: NewPlaceArguments(isHome: true),
                    );
                  },
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey
                  ),
                ),
                const Divider(height: 0),
                ListTile(
                  title: Text(
                    controller.app.userInfo.job != null
                    ? controller.app.userInfo.job!.title
                    : 'Agregar Trabajo'
                  ),
                  leading: const Icon(
                    Icons.business_center_outlined,
                    color: Palette.primary,
                  ),
                  onTap: () {
                    Get.to(
                      () => const NewPlacePage(),
                      binding: NewPlaceBinding(),
                      arguments: NewPlaceArguments(isHome: false),
                    );
                  },
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey
                  ),
                ),
                const Divider(),
              ],
            ),
            const Text(
              'CONFIGURACIÓN',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              )
            ),
            ListTile(
              title: const Text('Notificaciones'),
              trailing: Switch(
                value: controller.notificationsSwitch.isTrue,
                onChanged: (value) async {
                  if (!value) {
                    showDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text('Oops!'),
                        content: const Text(
                          'Para desactivar las notificaciones debe hacerlo desde el menu de configuración de su iPhone'
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text(
                              'Aceptar'
                            )
                          )
                        ]
                      )
                    );
                    return;
                  }
                  await Get.to(() => const NotificationsDialogPage(), binding: NotificationsDialogBinding());
                  await controller.getCheckNotificationPermStatus();
                },
              )
            ),
            ListTile(
              title: const Text('Privacidad'),
              onTap: () {
                Get.to(() => const PrivacyPage(), binding: PrivacyBinding());
              },
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            ListTile(
              title: const Text('Términos y condiciones'),
              onTap: () => launch(
                'https://plass.app/terminos-y-condiciones-usuario/'
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            ListTile(
              title: const Text('Tratamiento de datos'),
              onTap: () => launch(
                'https://plass.app/politicas-de-privacidad/'
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        )
      )
    ));
  }

}