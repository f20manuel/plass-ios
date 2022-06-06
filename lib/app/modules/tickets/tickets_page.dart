import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plass/app/modules/tickets/tickets_controller.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/help/help_binding.dart';
import 'package:plass/help/help_page.dart';
import 'package:plass/models/ticket.dart';

class TicketsPage extends GetView<TicketsController> {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Mis tickets'),
            actions: [
              IconButton(
                  onPressed: () =>
                      Get.to(() => const HelpPage(), binding: HelpBinding()),
                  icon: const Icon(Icons.add_circle_rounded),
                  color: Palette.primary
              )
            ]
        ),
        body: Obx(() {
          if (controller.tickets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.manage_search_rounded,
                    color: Colors.grey.shade400,
                    size: 120,
                  ),
                  const Divider(color: Colors.transparent),
                  Text(
                    'No tienes tickets',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 24,
                    )
                  )
                ]
              )
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controller.tickets.length,
            itemBuilder: (context, index) {
              TicketModel ticket = controller.tickets[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10.0),
                  child: ListTile(
                    onTap: () => controller.openTicket(ticket),
                    leading: Stack(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Material(
                            elevation: 5,
                            color: Palette.primary,
                            borderRadius: BorderRadius.circular(100.0),
                            child: const Icon(
                              Icons.confirmation_num_rounded,
                              color: Colors.white
                            )
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: SizedBox(
                            width: 16.0,
                            height: 16.0,
                            child: Material(
                              elevation: 5,
                              color: ticket.answer != null
                              ? Palette.secondary
                              : Colors.orange,
                              borderRadius: BorderRadius.circular(100.0),
                              child: Center(
                                child: Icon(
                                  ticket.answer != null
                                  ? Icons.check_rounded
                                  : Icons.timer_outlined,
                                  color: ticket.answer != null
                                  ? Colors.white
                                  : Palette.secondary,
                                  size: 8.0,
                                )
                              )
                            ),
                          )
                        )
                      ],
                    ),
                    title: Text(
                      ticket.answer != null
                      ? 'Agente: ${ticket.answer}'
                      : 'Tú: ${ticket.message}'
                    ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(DateTime.now()) == DateFormat('dd/MM/yyyy').format(ticket.answerAt?.toDate() ?? DateTime.now())
                      ? 'Hoy, ${DateFormat('hh:mm a').format(ticket.answerAt?.toDate() ?? DateTime.now()).toLowerCase()}'
                      : DateFormat('dd/MM/yyyy, hh:mm a').format(ticket.answerAt?.toDate() ?? DateTime.now()).toLowerCase()
                    ),
                    trailing: ticket.answer != null
                      ? const Icon(Icons.chevron_right_rounded)
                      : IconButton(
                        onPressed: () => controller.deleteTicket(ticket),
                        icon: const Icon(
                          Icons.remove_circle_rounded
                        )
                      )
                  ),
                ),
              );
            },

          );
        })
    );
  }
}
