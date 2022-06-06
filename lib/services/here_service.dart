import 'dart:async';

import 'package:get/get.dart';
import 'package:here_sdk/core.dart';
import 'package:location/location.dart' as l;

class HereService extends GetxService {
  final location = l.Location();
  final granted = l.PermissionStatus.granted;
  Future<GeoCoordinates?> getMyLocation() async {
    l.PermissionStatus permission = await location.hasPermission();

    if (permission == l.PermissionStatus.granted) {
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return null;
        }
      }

      l.LocationData myLocation = await location.getLocation();

      return GeoCoordinates(myLocation.latitude!, myLocation.longitude!);
    }

    return null;
  }
}