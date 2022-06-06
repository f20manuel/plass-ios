import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/driver.dart';

class FakeDriverService extends GetxService {
  Future<DriverModel> add(Map<String, dynamic> data, {String? doc}) async {
    DocumentReference newUser = await Firestore
        .fakeCollection('driver').add(data);
    if (doc != null) {
      await Firestore
          .fakeCollection('driver').doc(doc).set(data);
      newUser = Firestore.fakeCollection('driver').doc(doc);
    }
    DocumentSnapshot document = await newUser.get();
    DriverModel model = DriverModel.fromDocumentSnapshot(document);
    return model;
  }

  Future<DriverModel?> getModel(dynamic document) async {
    DriverModel? user;
    switch (document.runtimeType) {
      case String:
        DocumentSnapshot documentSnapshot = await Firestore
            .fakeCollection('driver')
            .doc(document)
            .get();

        if (documentSnapshot.exists) {
          user = DriverModel.fromDocumentSnapshot(documentSnapshot);
        }
        break;
      case DocumentReference:
        DocumentSnapshot documentSnapshot = await document.get();

        if (documentSnapshot.exists) {
          user = DriverModel.fromDocumentSnapshot(documentSnapshot);
        }
        break;
      case DocumentSnapshot:
        if (document.exists) {
          user = DriverModel.fromDocumentSnapshot(document);
        }
    }

    return user;
  }
}