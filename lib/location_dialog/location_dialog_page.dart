import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/location_dialog/location_dialog_controller.dart';

class LocationDialogPage extends GetView<LocationDialogController> {
  const LocationDialogPage({Key? key}) : super(key: key);

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
                        child: const Image(
                            image: AssetImage('assets/main/Artwork.png'),
                            width: 200,
                            fit: BoxFit.contain
                        )
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width - 32,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: const Text(
                          'Habilitar Localización',
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
                          'Brindar tu ubicación'
                      ),
                      subtitle: const Text(
                          'Al momento de solicitar un viaje podras ver tu ubicación en tiempo real.'
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
                          'Facilitar encuentro'
                      ),
                      subtitle: const Text(
                          'Al conocer tu ubicación en tiempo real tu compañero de viaje podrar ir por ti con mayor facilidad.'
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
                          onPressed: () {
                            controller.requestLocationPermissions();
                          },
                        )
                    ),
                  ]
              )
          ),
        )
    );
  }
}