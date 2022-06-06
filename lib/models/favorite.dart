import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:here_sdk/core.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/direction.dart';

class FavoriteModel {
  late bool isForDestination;
  late GeoCoordinates coords;
  late String title;

  FavoriteModel({
    required this.isForDestination,
    required this.coords,
    required this.title,
  });

  FavoriteModel.fromMapJson(Map data) {
    isForDestination = data['is_for_destination'];
    coords = GeoCoordinates(data['latitude'], data['longitude']);
    title = data['title'];
  }
}

class FavoritePlaceModel {
  String? id;
  late DirectionModel address;
  late String title;
  late DocumentReference userReference;

  FavoritePlaceModel({
    this.id,
    required this.address,
    required this.title,
    required this.userReference,
  });

  FavoritePlaceModel.fromDocumentSnapshot(DocumentSnapshot document) {
    id = document.id;
    address = DirectionModel.fromMapJson({
      'title': document['address']['title'],
      'latitude': document['address']['latitude'],
      'longitude': document['address']['longitude'],
    });
    title = document['title'];
    userReference = Firestore.collection('users').doc(document['user_uid']);
  }
}