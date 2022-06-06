import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:here_sdk/mapview.dart';
import 'package:plass/models/position.dart';

class TrackingModel {
  String? id;
  late PositionModel position;
  late String userUid;
  late LocationIndicator indicator;

  TrackingModel({
    this.id,
    required this.position,
    required this.userUid,
    required this.indicator,
  });

  TrackingModel.fromDocumentSnapshot(DocumentSnapshot document) {
    id = document.id;
    position = PositionModel.fromMapJson(document['position']);
    userUid = document['user_uid'];
    indicator = LocationIndicator();
  }
}