import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:get/get.dart';
import 'package:plass/app/data/enums/payment_method.dart';
import 'package:plass/app/data/providers/firestore.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/chat.dart';
import 'package:plass/models/direction.dart';
import 'package:plass/models/driver.dart';
import 'package:plass/models/user_payment_method.dart';
import 'package:plass/services/drivers_service.dart';
import 'package:plass/services/notifications_service.dart';

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
       String?            id;
  late DocumentReference? reference;
  late DocumentReference  customer;
       DocumentReference? driver;
  late DirectionModel     pickup;
  late DirectionModel     drop;
  late bool               couldByWoman;
  late List               comments;
       PaymentMethodType? paymentMethod;
  late num                tripCost;
  late BookingStatus      status;
  late String             statusString;
  late Timestamp          limit;
       String?            carType;
  late String             rate;
  late String             estimatedTime;
  late String             customerComment;
  late bool               customerCommented;
  late bool               notificationPending;
  late double             customerRate;
  late Timestamp          createdAt;
  late Timestamp          updatedAt;

  BookingModel({
             this.id,
             this.reference,
    required this.customer,
             this.driver,
    required this.pickup,
    required this.drop,
    required this.couldByWoman,
    required this.comments,
             this.paymentMethod,
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
    reference = Firestore.collection('bookings').doc(document.id);
    customer = Firestore.collection('users').doc(document['customer']);
    driver = document['driver'] != null ? Firestore.collection('driver').doc(document['driver']) : null;
    pickup = DirectionModel.fromMapJson(document['pickup']);
    drop = DirectionModel.fromMapJson(document['drop']);
    couldByWoman = document['could_by_woman'];
    comments = document['comments'];
    paymentMethod = EnumToString.fromString(PaymentMethodType.values, document['payment_method']);
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
    customer            = Firestore.collection('users').doc(json['customer']);
    driver              = json['driver'] != null ? Firestore.collection('driver').doc(json['driver']) : null;
    pickup              = DirectionModel.fromMapJson(json['pickup']);
    drop                = DirectionModel.fromMapJson(json['drop']);
    couldByWoman        = json['could_by_woman'];
    comments            = json['comments'];
    paymentMethod       = EnumToString.fromString(PaymentMethodType.values, json['payment_method']);
    tripCost            = json['trip_cost'];
    status              = statusConverter(json['status']);
    statusString        = bookingStatusToEspanish(json['status']);
    limit               = json['search_limit'];
    rate                = '0';
    estimatedTime       = json.containsKey("estimated_time") ? json['estimated_time'] : '0 m.';
    customerComment     = json['customer_comment'];
    customerCommented   = json['customer_commented'];
    customerRate        = json['customer_rate'];
    notificationPending = json['notification_pending'];
    createdAt           = json['created_at'];
    updatedAt           = json['updated_at'];
    if (json.containsKey('car_type')) {
      carType = json['car_type'];
    }
  }

  Future<ChatModel> getChat() async {
    DocumentSnapshot document = await Firestore
      .collection('chats')
      .doc('${driver?.id ?? ''}-${customer.id}-${id ?? ''}')
      .get();

    ChatModel chat = ChatModel.fromDocumentSnapshot(document);

    return chat;
  }

  Future<DriverModel?> getDriverInfo() async {
    final DriverService driverServices = Get.find();
    if (driver != null) {
      DriverModel? model = await driverServices.getModel(driver!.id);
      return model;
    }

    return null;
  }

  String paymentMethodLocale() {
    String _method = 'Efectivo';
    switch (paymentMethod) {
      case PaymentMethodType.nequi:
        _method = 'Nequi';
        break;
      case PaymentMethodType.daviplata:
        _method = 'Daviplata';
        break;
    }

    return _method;
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

  Future<void> sendNotificationPending() async {
    try {
      final DriverService driverService = Get.find();
      final NotificationsService notificationsService = Get.find();
      if (!notificationPending) {
        List<DriverModel> drivers = await driverService.getApprovedDrivers();
        if (drivers.isNotEmpty) {
          for (DriverModel driverModel in drivers) {
            if (driverModel.carType == carType && driverModel.isConnected) {
              // double distance = await driverModel.distanceTo(pickup);
              // if (distance < 4000) {
              notificationsService.sendPushNotifications(
                  "¡Nuevo servicio disponible!",
                  "Hay un nuevo servicio...",
                  driverModel.token
              );
              // }
            }
          }
        }

        if (reference != null) {
          await reference?.update({
            'notification_pending': true
          });
        }
      }
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
    } on FirebaseException catch (exception) {
      Firestore.generateLog(exception, "Function sendNotificationPending => lib/models/booking.dart");
    }
  }

  Future<void> delete() async {
    try {
      await Firestore.collection('bookings').doc(id).delete();
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
    } on FirebaseException catch (exception) {
      Firestore.generateLog(exception, "Function delete in lib/models/booking.dart");
    }
  }
}