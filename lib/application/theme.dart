import 'package:flutter/material.dart';

class Palette {
  Palette._(); // this basically makes it so you can instantiate this class

  static const _primaryValue = 0xFF41D5FB;
  static const _secondaryValue = 0xFF222B45;
  static const _lilaValue = 0xFFD4AAFF;

  static const MaterialColor primary = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color.fromRGBO(65, 213, 251, 0.1),
      100: Color.fromRGBO(65, 213, 251, 0.2),
      200: Color.fromRGBO(65, 213, 251, 0.3),
      300: Color.fromRGBO(65, 213, 251, 0.4),
      400: Color.fromRGBO(65, 213, 251, 0.5),
      500: Color.fromRGBO(65, 213, 251, 0.6),
      600: Color.fromRGBO(65, 213, 251, 0.7),
      700: Color.fromRGBO(65, 213, 251, 0.8),
      800: Color.fromRGBO(65, 213, 251, 0.9),
      900: Color.fromRGBO(65, 213, 251, 1),
    },
  );

  static const MaterialColor secondary = MaterialColor(
    _secondaryValue,
    <int, Color>{
      50: Color.fromRGBO(34, 43, 69, 0.1),
      100: Color.fromRGBO(34, 43, 69, 0.2),
      200: Color.fromRGBO(34, 43, 69, 0.3),
      300: Color.fromRGBO(34, 43, 69, 0.4),
      400: Color.fromRGBO(34, 43, 69, 0.5),
      500: Color.fromRGBO(34, 43, 69, 0.6),
      600: Color.fromRGBO(34, 43, 69, 0.7),
      700: Color.fromRGBO(34, 43, 69, 0.8),
      800: Color.fromRGBO(34, 43, 69, 0.9),
      900: Color.fromRGBO(34, 43, 69, 1),
    },
  );

  static const MaterialColor lila = MaterialColor(
    _lilaValue,
    <int, Color>{
      50: Color.fromRGBO(212, 170, 255, 0.1),
      100: Color.fromRGBO(212, 170, 255, 0.2),
      200: Color.fromRGBO(212, 170, 255, 0.3),
      300: Color.fromRGBO(212, 170, 255, 0.4),
      400: Color.fromRGBO(212, 170, 255, 0.5),
      500: Color.fromRGBO(212, 170, 255, 0.6),
      600: Color.fromRGBO(212, 170, 255, 0.7),
      700: Color.fromRGBO(212, 170, 255, 0.8),
      800: Color.fromRGBO(212, 170, 255, 0.9),
      900: Color.fromRGBO(212, 170, 255, 1),
    },
  );
}