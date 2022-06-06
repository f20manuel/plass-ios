import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/direction.dart';
import 'package:plass/models/tracking.dart';
import 'package:plass/models/user.dart';

String driverCollection = 'driver';

class DriverModel {
  String? id;
  late bool approved;
  late bool isConnected;
  late String avatar;
  late String firstName;
  late String? lastName;
  late String mobile;
  late bool mobileVerified;
  late int document;
  late List coupons;
  late DirectionModel? home;
  late DirectionModel? job;
  late Gender gender;
  late String email;
  late String carType;
  late double rate;
  late Map settings;
  late String token;
  late String vehicleBrand;
  late String vehicleLine;
  late String vehicleColor;
  late String vehicleNumber;
  late int vehicleYear;
  late Timestamp createdAt;
  late Timestamp updatedAt;

  DriverModel({
    required this.approved,
    required this.isConnected,
    required this.avatar,
    required this.firstName,
    this.lastName = '',
    required this.mobile,
    required this.mobileVerified,
    required this.document,
    required this.coupons,
    required this.gender,
    required this.email,
    required this.carType,
    required this.settings,
    required this.token,
    required this.vehicleBrand,
    required this.vehicleLine,
    required this.vehicleColor,
    required this.vehicleNumber,
    required this.rate,
    required this.vehicleYear,
    required this.createdAt,
    required this.updatedAt,
  });

  DriverModel.fromDocumentSnapshot(DocumentSnapshot document) {
    id = document.id;
    approved = document['approved'];
    isConnected = (document.data() as Map).containsKey("isConnected") ? document["isConnected"] : false;
    avatar = document['avatar'];
    firstName = document['first_name'];
    lastName = document['last_name'];
    mobile = document['mobile'];
    mobileVerified = document['phone_verified'];
    coupons = document['coupons'];
    home = document['home'].isNotEmpty
        ? DirectionModel.fromMapJson(document['home'])
        : null;
    job = document['job'].isNotEmpty
        ? DirectionModel.fromMapJson(document['home'])
        : null;
    gender = document['gender'] == 'male' ? Gender.male : Gender.female;
    email = document['email'];
    settings = document['settings'];
    token = document['token'];
    carType = document['car_type'];
    vehicleBrand = document['vehicle_brand'];
    vehicleLine = document['vehicle_line'];
    vehicleColor = document['vehicle_color'];
    vehicleNumber = document['vehicle_number'];
    vehicleYear = document['vehicle_year'];
    rate = 0.0;
    createdAt = document['created_at'];
    updatedAt = document['updated_at'];
  }

  Future<double> distanceTo(DirectionModel position) async {
    double result = 0.0;
    try {
      DocumentSnapshot document = await Firestore
          .collection("tracking")
          .doc(id)
          .get();

      if (document.exists) {
        TrackingModel model = TrackingModel.fromDocumentSnapshot(document);
        result = model.position.coords.distanceTo(position.coords);
      }
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
    } on FirebaseException catch (exception) {
      Firestore.generateLog(exception, "Function distanceTo => lib/models/driver.dart");
    }
    return result;
  }
}