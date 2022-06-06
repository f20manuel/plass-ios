import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  late String from;
  late String message;
  late String status;
  late int date;

  MessageModel({
    required this.from,
    required this.message,
    required this.status,
    required this.date,
  });

  MessageModel.fromMap(Map msg) {
    from = msg['from'];
    message = msg['message'];
    status = msg['status'];
    date = msg['date'];
  }

  Map toJson() {
    return {
      'from': from,
      'message': message,
      'status': status,
      'date': date,
    };
  }
}