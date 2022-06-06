import 'package:get/get.dart';
import 'package:plass/help/last_trip_problem/missing_item/missing_item_binding.dart';
import 'package:plass/help/last_trip_problem/missing_item/missing_item_page.dart';
import 'package:plass/help/last_trip_problem/payment_problem/payment_problem_binding.dart';
import 'package:plass/help/last_trip_problem/payment_problem/payment_problem_page.dart';
import 'package:plass/models/help.dart';

class LastTripProblemService extends GetxService {
  List<HelpMenuItemModel> menu = [
    HelpMenuItemModel(
      title: 'Objeto perdido',
      page: MissingItemPage(),
      binding: MissingItemBinding(),
    ),
    HelpMenuItemModel(
      title: 'Problema con el cobro',
      page: PaymentProblemPage(),
      binding: PaymentProblemBinding(),
    ),
  ];
}