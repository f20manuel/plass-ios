import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:plass/fake/services/driver_service.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/driver.dart';

enum PaymentMethod {
  creditCard,
  debitCard,
  pse,
  cash,
  nequi,
  bancolombia,
}

enum BookingStatus {
  selectCar,
  pending,
  waiting,
  pickup,
  drop,
  finish,
  cancel,
  current,
}

class BookingModel {
  String? id;
  late DocumentReference? reference;
  late DocumentReference customer;
  DocumentReference? driver;
  late bool couldByWoman;
  late List comments;
  late PaymentMethod paymentMethod;
  late num tripCost;
  late BookingStatus status;
  late String statusString;
  late Timestamp limit;
  String? carType;
  late String rate;
  late String estimatedTime;
  late String customerComment;
  late bool customerCommented;
  late bool notificationPending;
  late double customerRate;
  late Timestamp createdAt;
  late Timestamp updatedAt;

  BookingModel({
    this.id,
    this.reference,
    required this.customer,
    this.driver,
    required this.couldByWoman,
    required this.comments,
    required this.paymentMethod,
    required this.tripCost,
    required this.status,
    required this.statusString,
    required this.limit,
    this.carType,
    required this.rate,
    required this.estimatedTime,
    required this.customerComment,
    required this.customerCommented,
    required this.customerRate,
    required this.notificationPending,
    required this.createdAt,
    required this.updatedAt,
  });

  BookingModel.fromDocumentSnapshot(DocumentSnapshot document) {
    Map? data = document.data() != null ? document.data()! as Map : null;
    id = document.id;
    reference = Firestore.fakeCollection('bookings').doc(document.id);
    customer = Firestore.fakeCollection('users').doc(document['customer']);
    driver = document['driver'] != null ? Firestore.fakeCollection('driver').doc(document['driver']) : null;
    couldByWoman = document['could_by_woman'];
    comments = document['comments'];
    paymentMethod = paymentMethodConverter(document['payment_method']);
    tripCost = document['trip_cost'];
    status = statusConverter(document['status']);
    statusString = bookingStatusToEspanish(document['status']);
    limit = document['search_limit'];
    rate = '0';
    estimatedTime = (document.data() as Map<String, dynamic>).containsKey("estimated_time") ? document['estimated_time'] : '0 m.';
    customerComment = document['customer_comment'];
    customerCommented = document['customer_commented'];
    customerRate = document['customer_rate'];
    notificationPending = document['notification_pending'];
    createdAt = document['created_at'];
    updatedAt = document['updated_at'];
    if (data != null && data.containsKey('car_type')) {
      carType = document['car_type'];
    }
  }

  BookingModel.fromJson(Map<String, dynamic> json) {
    customer = Firestore.fakeCollection('users').doc(json['customer']);
    driver = json['driver'] != null ? Firestore.fakeCollection('driver').doc(json['driver']) : null;
    couldByWoman = json['could_by_woman'];
    comments = json['comments'];
    paymentMethod = paymentMethodConverter(json['payment_method']);
    tripCost = json['trip_cost'];
    status = statusConverter(json['status']);
    statusString = bookingStatusToEspanish(json['status']);
    limit = json['search_limit'];
    rate = '0';
    estimatedTime = json.containsKey("estimated_time") ? json['estimated_time'] : '0 m.';
    customerComment = json['customer_comment'];
    customerCommented = json['customer_commented'];
    customerRate = json['customer_rate'];
    notificationPending = json['notification_pending'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json.containsKey('car_type')) {
      carType = json['car_type'];
    }
  }

  Future<DriverModel?> getDriverInfo() async {
    final FakeDriverService driverServices = Get.find();
    if (driver != null) {
      DriverModel? model = await driverServices.getModel(driver!.id);
      return model;
    }

    return null;
  }

  String bookingStatusToEspanish(String bookingStatus) {
    String _status = 'Pendiente';
    switch (bookingStatus) {
      case 'select_car':
        _status = 'Seleccioando vehículo';
        break;
      case 'pending':
        _status = 'Pendiente';
        break;
      case 'waiting':
        _status = 'El afiliado te esta esperando';
        break;
      case 'pickup':
        _status = 'Esperando al afiliado';
        break;
      case 'drop':
        _status = 'En curso';
        break;
      case 'finish':
        _status = 'Finalizado';
        break;
    }

    return _status;
  }

  PaymentMethod paymentMethodConverter (String method) {
    PaymentMethod _paymentMethod = PaymentMethod.cash;
    switch (method) {
      case 'cash':
        _paymentMethod = PaymentMethod.cash;
        break;
    }

    return _paymentMethod;
  }

  BookingStatus statusConverter (String bookingStatus) {
    BookingStatus _status = BookingStatus.pending;
    switch (bookingStatus) {
      case 'select_car':
        _status = BookingStatus.selectCar;
        break;
      case 'pending':
        _status = BookingStatus.pending;
        break;
      case 'waiting':
        _status = BookingStatus.waiting;
        break;
      case 'pickup':
        _status = BookingStatus.pickup;
        break;
      case 'drop':
        _status = BookingStatus.drop;
        break;
      case 'finish':
        _status = BookingStatus.finish;
        break;
      case 'cancel':
        _status = BookingStatus.cancel;
    }

    return _status;
  }
}