import 'package:get/get.dart';
import 'package:plass/help/account_problem/my_account_problem/my_account_problem_binding.dart';
import 'package:plass/help/account_problem/my_account_problem/my_account_problem_page.dart';
import 'package:plass/models/help.dart';

class AccountProblemService extends GetxService {
  List<HelpMenuItemModel> menu = [
    HelpMenuItemModel(
      title: 'Si tienes problemas con tu cuenta.',
      page: MyAccountProblemPage(),
      binding: MyAccountProblemBinding(),
    )
  ];
}