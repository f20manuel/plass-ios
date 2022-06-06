import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/message.dart';

class ChatModel {
  String? id;
  DocumentReference? reference;
  late Timestamp createdAt;
  late List<MessageModel> messages;
  late Map participants;

  ChatModel({
    this.id,
    this.reference,
    required this.createdAt,
    required this.messages,
    required this.participants,
  });

  ChatModel.fromDocumentSnapshot(DocumentSnapshot document) {
    id = document.id;
    reference = Firestore.collection('chats').doc(document.id);
    createdAt = document['created_at'];
    messages = [];
    for (Map msg in document['messages']) {
      MessageModel msgModel = MessageModel.fromMap(msg);
      messages.add(msgModel);
    }
    participants = document['participants'];
  }

  Future<void> readAllMessages() async {
    try {
      List<Map> _messages = [];
      for (MessageModel message in messages) {
        Map _message = message.toJson();
        if (message.from == "driver" && message.status != "read") {
          _message["status"] = "read";
        }
        _messages.add(_message);
      }

      if (reference != null) {
        await reference!.update({
          'messages': _messages,
        });
      }
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
    } on FirebaseException catch (exception) {
      Firestore.generateLog(exception, "Function readAllMessages => lib/models/chat.dart");
    }
  }
}