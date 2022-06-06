import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/user.dart';

class FakeUsersService extends GetxService {
  Future<UserModel> add(Map<String, dynamic> data, {String? doc}) async {
    DocumentReference newUser = await Firestore
      .fakeCollection('users').add(data);
    if (doc != null) {
      await Firestore
        .fakeCollection('users').doc(doc).set(data);
      newUser = Firestore.fakeCollection('users').doc(doc);
    }
    DocumentSnapshot document = await newUser.get();
    UserModel model = UserModel.fromDocumentSnapshot(document);
    return model;
  }

  Future<UserModel?> getModel(dynamic document) async {
    UserModel? user;
    switch (document.runtimeType) {
      case String:
        DocumentSnapshot documentSnapshot = await Firestore
        .fakeCollection('users')
        .doc(document)
        .get();

        if (documentSnapshot.exists) {
          user = UserModel.fromDocumentSnapshot(documentSnapshot);
        }
        break;
      case DocumentReference:
        DocumentSnapshot documentSnapshot = await document.get();

        if (documentSnapshot.exists) {
          user = UserModel.fromDocumentSnapshot(documentSnapshot);
        }
        break;
      case DocumentSnapshot:
        if (document.exists) {
          user = UserModel.fromDocumentSnapshot(document);
        }
    }

    return user;
  }
}