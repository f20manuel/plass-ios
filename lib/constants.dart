import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:get/get.dart';
import 'package:plass/app/modules/tickets/tickets_binding.dart';
import 'package:plass/app/modules/tickets/tickets_page.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/help/help_binding.dart';
import 'package:plass/help/help_page.dart';
import 'package:plass/home/home_controller.dart';
import 'package:plass/payments/payment_binding.dart';
import 'package:plass/payments/payment_page.dart';
import 'package:plass/settings/settings_binding.dart';
import 'package:plass/settings/settings_page.dart';

class PlassConstants {
  PlassConstants._();

  static final HomeController homeController = Get.find();

  static void notNetworkMessage() {
    Get.snackbar(
      "¡Sin conexión!",
      "No hemos detectado una conexión a internet.",
      icon: const Icon(Icons.signal_cellular_connected_no_internet_4_bar_rounded, color: Colors.white),
      backgroundColor: Colors.red,
      instantInit: true,
      colorText: Colors.white,
      margin: const EdgeInsets.all(0),
      duration: const Duration(seconds: 5),
      animationDuration: const Duration(milliseconds: 500),
      borderRadius:  0,
      shouldIconPulse: true,
    );
  }
  static GeoCoordinates bogotaCoords = GeoCoordinates(4.64, -74.10);
  static GeoCircle bogotaCircleArea = GeoCircle(bogotaCoords, 70000);
  static String defaultAvatar = 'https://plass-sas.imgix.net/defaults/avatar.png';
  static List<Map<String, dynamic>> drawerMenu = [
    {
      'label': 'Mis viajes',
      'icon': const Icon(
        Icons.file_copy_rounded,
        color: Palette.primary,
      ),
      'onPressed': () => homeController.goToCurrentBookings(),
    },
    {
      'label': 'Pagos',
      'icon': const Icon(
        Icons.account_balance_wallet_rounded,
        color: Colors.grey,
      ),
      'onPressed': () => Get.to(() => const PaymentPage(), binding: PaymentBinding()),
    },
    {
      'label': 'Ayuda',
      'icon': const Icon(
        Icons.support_agent_rounded,
        color: Palette.secondary,
      ),
      'onPressed': () => Get.to(() => const HelpPage(), binding: HelpBinding()),
    },
    {
      'label': 'Mis tickets',
      'icon': const Icon(
        Icons.confirmation_num_rounded,
        color: Colors.orange,
      ),
      'onPressed': () => Get.to(() => const TicketsPage(), binding: TicketsBinding()),
    },
    {
      'label': 'Configuración',
      'icon': const Icon(
        Icons.settings,
        color: Palette.primary,
      ),
      'onPressed': () => Get.to(() => const SettingsPage(), binding: SettingsBinding()),
    },
  ];
}