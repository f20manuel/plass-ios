import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:plass/firestore.dart';
import 'package:plass/fake/models/booking.dart';

class FakeBookingsService extends GetxService {
  Future<BookingModel> add(Map<String, dynamic> data, {String? doc}) async {
    DocumentReference newUser = await Firestore
        .fakeCollection("bookings").add(data);
    if (doc != null) {
      await Firestore
        .fakeCollection("bookings").doc(doc).set(data);
      newUser = Firestore.fakeCollection("bookings").doc(doc);
    }
    DocumentSnapshot document = await newUser.get();
    BookingModel model = BookingModel.fromDocumentSnapshot(document);
    return model;
  }

  Future<void> update(Map<String, dynamic> data, String doc) async {
    await Firestore
        .fakeCollection("bookings").doc(doc).update(data);
  }

  Future<BookingModel?> getModel(dynamic document) async {
    BookingModel? user;
    switch (document.runtimeType) {
      case String:
        DocumentSnapshot documentSnapshot = await Firestore
            .fakeCollection('bookings')
            .doc(document)
            .get();

        if (documentSnapshot.exists) {
          user = BookingModel.fromDocumentSnapshot(documentSnapshot);
        }
        break;
      case DocumentReference:
        DocumentSnapshot documentSnapshot = await document.get();

        if (documentSnapshot.exists) {
          user = BookingModel.fromDocumentSnapshot(documentSnapshot);
        }
        break;
      case DocumentSnapshot:
        if (document.exists) {
          user = BookingModel.fromDocumentSnapshot(document);
        }
    }

    return user;
  }
}