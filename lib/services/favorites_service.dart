import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/favorite.dart';

class FavoritesService extends GetxService {
  Stream<List<FavoritePlaceModel>> streamByUser(User? currentUser) {
    return Firestore.collection('favorite_places')
        .where('user_uid', isEqualTo: currentUser!.uid)
        .snapshots().map((querySnapshot) {
      List<FavoritePlaceModel> data = [];
      for (DocumentSnapshot document in querySnapshot.docs) {
        final model = FavoritePlaceModel.fromDocumentSnapshot(document);
        data.add(model);
      }
      return data;
    });
  }

  Future<DocumentReference?> add(Map<String, dynamic> data) async {
    try {
      DocumentReference result = await Firestore.collection('favorite_places')
          .add(data);
      return result;
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
      return null;
    } on FirebaseException catch(e) {
      Firestore.generateLog(e, 'Line 21 in lib/services/favorites_service.dart');
      return null;
    }
  }

  void update(String document, Map<String, dynamic> data) {
    Firestore.collection('favorite_places').doc(document).update(data);
  }
}