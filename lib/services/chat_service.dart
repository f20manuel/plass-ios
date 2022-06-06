import 'package:get/get.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/booking.dart';
import 'package:plass/models/chat.dart';

class ChatService extends GetxService {
  Stream<ChatModel> changes(BookingModel booking) {
    return Firestore
      .collection('chats')
      .doc('${booking.driver!.id}-${booking.customer.id}-${booking.id}')
      .snapshots()
      .map((document) {
        ChatModel model = ChatModel.fromDocumentSnapshot(document);
        return model;
      });
  }
}