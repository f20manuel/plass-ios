import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/notifications_dialog/notifications_dialog_controller.dart';

class NotificationsDialogPage extends GetView<NotificationsDialogController> {
  const NotificationsDialogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 32),
                      padding: const EdgeInsets.all(32.8),
                      decoration: BoxDecoration(
                        color: Palette.primary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: Colors.white,
                        size: 72,
                      )
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width - 32,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: const Text(
                          'Habilitar Notificaciones',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Nos permitirá:',
                          style: TextStyle(
                              color: Colors.grey.shade600
                          ),
                          textAlign: TextAlign.center,
                        )
                    ),
                    ListTile(
                      leading: Container(
                          decoration: const BoxDecoration(
                            color: Palette.primary,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                              Icons.my_location_rounded,
                              color: Colors.white
                          )
                      ),
                      title: const Text(
                          'Brindar información sobre cada viaje'
                      ),
                      subtitle: const Text(
                          'Podremos avisarte cuando un afiliado te escriba o este cerca de ti.'
                      ),
                    ),
                    ListTile(
                      leading: Container(
                          decoration: const BoxDecoration(
                            color: Palette.primary,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                              Icons.person_pin_circle_rounded,
                              color: Colors.white
                          )
                      ),
                      title: const Text(
                          'Avisar sobre promociones'
                      ),
                      subtitle: const Text(
                          'Podras estar al día con todas nuestras promociones y anuncios.'
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width - 32,
                        height: 59,
                        margin: const EdgeInsets.symmetric(vertical: 32),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ))
                          ),
                          child: const Text(
                              'Continuar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                          ),
                          onPressed: () => controller.requestPermissions(),
                        )
                    ),
                  ]
              )
          ),
        )
    );
  }
}