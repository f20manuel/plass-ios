import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/direction.dart';
import 'package:plass/models/user.dart';

class UsersService extends GetxService {
  final auth = FirebaseAuth.instance;

  Stream<UserModel> streamByUid(String uid) {
    return Firestore.collection('users')
    .doc(uid)
    .snapshots().map((document) {
      UserModel data = UserModel.fromDocumentSnapshot(document);
      return data;
    });
  }

  Future<void> updateAuth(Map<String, dynamic> data, {bool test = false}) async {
    DocumentReference userReference = Firestore.collection('users').doc(auth.currentUser!.uid);
    DocumentSnapshot user = await Firestore.collection('users').doc(auth.currentUser!.uid).get();

    if (user.exists) {
      await userReference.update(data);
    }
  }

  Future<List<DirectionModel>> getRecent() async {
    List<DirectionModel> list = [];
    QuerySnapshot query = await Firestore
      .collection("bookings")
      .where("customer", isEqualTo: auth.currentUser?.uid)
      .where("status", isEqualTo: "finish")
      .limit(10)
      .get();

    if (query.docs.isNotEmpty) {
      List<Map<String, dynamic>> _list = [];
      for (DocumentSnapshot document in query.docs) {
        Map<String, dynamic> booking = document.data() as Map<String, dynamic>;
        _list.add(booking["drop"]);
      }

      final Map<String, dynamic> mapFilter = {};

      for (Map<String, dynamic> myMap in _list) {
        mapFilter[myMap['title']] = myMap;
      }

      final List<Map<String, dynamic>> listFilter =
      mapFilter.keys.map((key) => mapFilter[key] as Map<String,dynamic>).toList();

      for (Map<String, dynamic> item in listFilter) {
        list.add(DirectionModel.fromMapJson(item));
      }
    }

    return list;
  }
}