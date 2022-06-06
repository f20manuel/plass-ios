import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

extension Firebase on GetInterface {
  Map<String, dynamic> documentSnapshotToMap(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data() as Map<String, dynamic>;
    json['id'] = document.id;
    return json;
  }
}