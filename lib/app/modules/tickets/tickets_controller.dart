import 'package:get/get.dart';
import 'package:plass/app/modules/tickets/tickets_repository.dart';

class TicketsController extends GetxController with TicketsRepository {
  @override
  void onInit() {
    ticketsList.bindStream(streamTickets());
    super.onInit();
  }
}