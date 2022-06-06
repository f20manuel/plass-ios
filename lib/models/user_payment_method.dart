import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plass/app/data/providers/firestore.dart';
import 'package:plass/firestore.dart';

class UserPaymentMethodModel {
  String? id;
  DocumentReference? user;
  DocumentReference? reference;
  late String currency;
  late String image;
  late String imageType;
  late String name;
  late bool active;

  UserPaymentMethodModel({
    this.id,
    this.user,
    required this.currency,
    required this.image,
    required this.imageType,
    required this.name,
    required this.active,
  });

  UserPaymentMethodModel.fromDocumentSnapshot(DocumentSnapshot document) {
    id        = document.id;
    user      = Firestore.collection('users').doc(document['user_uid']);
    reference = document.reference;
    currency  = document['currency'];
    image     = document['image'];
    imageType = document['image_type'];
    name      = document['name'];
    active    = document['status'];
  }

  UserPaymentMethodModel.fromJson(Map<String, dynamic> json) {
    id        = json['id'];
    user      = Firestore.collection('users').doc(json['user_uid']);
    reference = json['reference'];
    currency  = json['currency'];
    image     = json['image'];
    imageType = json['image_type'];
    name      = json['name'];
    active    = json['status'];
  }

  Map<String, dynamic> toJson(UserPaymentMethodModel model) {
    return {
      'id'        : model.id,
      'user_uid'  : model.user?.id,
      'currency'  : model.currency,
      'image'     : model.image,
      'image_type': model.imageType,
      'name'      : model.name,
      'status'    : model.active,
    };
  }

  // CREATE
  Future<void> add() async {
    Map<String, dynamic> data = toJson(this);
    data.remove('id');
    await Collection.userPaymentMethods.add(data);
  }

  // UPDATE
  Future<void> select() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    QuerySnapshot query = await Collection.userPaymentMethods
    .where('user_uid', isEqualTo: auth.currentUser?.uid)
    .get();

    for (DocumentSnapshot document in query.docs) {
      document.reference.update({
        'status': false,
      });
    }

    await Collection.userPaymentMethods.doc(id).update({
      'status': true
    });
  }

  // DELETE
  Future<void> delete() async {
    await reference?.delete();
  }
}