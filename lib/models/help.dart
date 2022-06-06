import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HelpMenuItemModel {
  late String title;
  late Widget? page;
  late Bindings? binding;

  HelpMenuItemModel({
    required this.title,
    this.page,
    this.binding,
  });
}