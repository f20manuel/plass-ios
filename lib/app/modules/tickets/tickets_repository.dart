import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plass/app/data/providers/firestore.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/models/ticket.dart';

class TicketsRepository {
  var ticketsList = Rx<List<TicketModel>>([]);
  List<TicketModel> get tickets => ticketsList.value;

  Stream<List<TicketModel>> streamTickets() {
    List<TicketModel> list = [];
    Stream<QuerySnapshot> queryStream = Collection.myTickets.snapshots();
    queryStream.listen((event) {
      if (event.docChanges.isNotEmpty) {
        list.clear();
      }
    });
    return queryStream.map((querySnapshot) {
      for (DocumentSnapshot document in querySnapshot.docs) {
        list.add(TicketModel.fromDocumentSnapshot(document));
      }
      return list.toList();
    });
  }

  void openTicket(TicketModel ticket) {
    if(!Get.isDialogOpen!) {
      Get.defaultDialog(
        textCancel: 'Cerrar',
        textConfirm: 'Eliminar Ticket',
        onConfirm: () {
          Get.back();
          deleteTicket(ticket);
        },
        cancelTextColor: Palette.primary,
        confirmTextColor: Colors.white,
        title: ticket.type,
        content: Column(
          children: [
            Container(
              width: Get.width - 64,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                  ),
                  const BoxShadow(
                    color: Colors.white54,
                    spreadRadius: -5.0,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Bubble(
                    elevation: 5,
                    alignment: Alignment.topRight,
                    nip: BubbleNip.rightTop,
                    child: Text(ticket.message)
                  ),
                  const Divider(color: Colors.transparent),
                  Bubble(
                    elevation: 5,
                    alignment: Alignment.topLeft,
                    color: Palette.primary,
                    nip: BubbleNip.leftTop,
                    child: Text(
                      ticket.answer ?? '',
                      style: const TextStyle(color: Colors.white
                    ))
                  ),
                ]
              ),
            )
          ]
        )
      );
    }
  }

  void deleteTicket(TicketModel ticket) {
    if (!Get.isDialogOpen!) {
      Get.defaultDialog(
        title: "Eliminar ticket",
        content: const Text("¿Desea eliminar este ticket?"),
        confirm: ElevatedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)
            ))
          ),
          onPressed: () {
            ticket.delete();
            Get.back();
          },
          child: const Text('Si, eliminar')
        ),
        cancel: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Palette.primary),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
              side: const BorderSide(
                width: 2,
                color: Palette.primary
              )
            ))
          ),
          onPressed: () => Get.back(),
          child: const Text('Cancelar')
        )
      );
    }
  }
}