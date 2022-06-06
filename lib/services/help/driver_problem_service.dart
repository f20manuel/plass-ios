import 'package:get/get.dart';
import 'package:plass/help/driver_problem/vehicle_problem/vehicle_problem_binding.dart';
import 'package:plass/help/driver_problem/vehicle_problem/vehicle_problem_page.dart';
import 'package:plass/models/help.dart';

class DriverProblemService extends GetxService {
  List<HelpMenuItemModel> menu = [
    HelpMenuItemModel(
      title: 'Si el comportamiento del conductor fué inadecuado, si el estado del vehículo no era el indicado o la descripción del conductor y/o la del vehículo no coinciden.',
      page: VehicleProblemPage(),
      binding: VehicleProblemBinding()
    )
  ];
}