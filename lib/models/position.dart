import 'package:here_sdk/core.dart';

class PositionModel {
  late int heading;
  late GeoCoordinates coords;
  late double speed;

  PositionModel({
    required this.heading,
    required this.coords,
    required this.speed,
  });

  PositionModel.fromMapJson(Map<String, dynamic> map) {
    heading = int.parse(double.parse(map['heading'].toString()).toStringAsFixed(0));
    coords = GeoCoordinates(map['latitude'].toDouble(), map['longitude'].toDouble());
    speed = map['speed'].toDouble();
  }
}