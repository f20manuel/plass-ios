import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/delete_account_dialog/delete_account_dialog_controller.dart';

class DeleteAccountDialogPage extends GetView<DeleteAccountDialogController> {
  const DeleteAccountDialogPage({Key? key}) : super(key: key);

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
                        Icons.no_accounts_rounded,
                        color: Colors.white,
                        size: 72,
                      )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 32,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: const Text(
                        'Eliminar cuenta',
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
                        'NOTA:',
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
                          Icons.timer,
                          color: Colors.white
                        )
                      ),
                      title: const Text(
                        'Recuperar cuenta'
                      ),
                      subtitle: const Text(
                        'Al eliminar tu cuenta tienes un plazo de hasta 15 días para recuperarla ingresando de nuevo.'
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
                        onPressed: () => controller.delete(),
                      )
                    ),
                  ]
              )
          ),
        )
    );
  }
}