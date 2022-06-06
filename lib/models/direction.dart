import 'package:here_sdk/core.dart';

class DirectionModel {
  late String title;
  late String? description;
  late GeoCoordinates coords;

  DirectionModel({
    required this.title,
    this.description,
    required this.coords,
  });

  DirectionModel.fromMapJson(Map<String, dynamic> data) {
    title = data['title'];
    description = data['description'];
    coords = GeoCoordinates(data['latitude'], data['longitude']);
  }

  Map toJson() {
    return {
      'title': title,
      'latitude': coords.latitude,
      'longitude': coords.longitude
    };
  }
}