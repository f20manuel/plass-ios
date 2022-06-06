import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/direction.dart';
import 'package:plass/models/driver.dart';
import 'package:plass/services/drivers_service.dart';

String userCollection = 'users';

enum Gender {
  male,
  female
}

class UserNotification {
  late bool sms;
  late bool email;

  UserNotification({
    required this.sms,
    required this.email,
  });

  UserNotification.fromJson(Map<String, dynamic> json) {
    sms = json['sms'];
    email = json['json'];
  }

  Map<String, dynamic> toJson() {
    return {
      'sms': sms,
      'email': email,
    };
  }
}

class UserSettings {
  late UserNotification notifications;

  UserSettings({
    required this.notifications,
  });

  UserSettings.fromJson(Map<String, dynamic> json) {
    notifications = UserNotification(
      sms: json['notifications']['sms'],
      email: json['notifications']['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.toJson(),
    };
  }
}

class UserModel {
  String? id;
  late String avatar;
  late String firstName;
  late String? lastName;
  late String mobile;
  late bool mobileVerified;
  late List coupons;
  late DirectionModel? home;
  late DirectionModel? job;
  late Gender gender;
  late String email;
  late String smsCode;
  late Timestamp smsCodeExpire;
  late UserSettings settings;
  String? referred;
  late List fcmTokens;
  late Timestamp? softDelete;
  late Timestamp createdAt;
  late Timestamp updatedAt;

  UserModel({
    required this.avatar,
    required this.firstName,
    this.lastName = '',
    required this.mobile,
    required this.mobileVerified,
    required this.coupons,
    required this.gender,
    required this.email,
    this.home,
    this.job,
    required this.smsCode,
    required this.smsCodeExpire,
    required this.settings,
    this.referred,
    required this.fcmTokens,
    required this.softDelete,
    required this.createdAt,
    required this.updatedAt,
  });

  final DriverService driverService = Get.find();

  UserModel.fromDocumentSnapshot(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    id = document.id;
    avatar = document['avatar'];
    firstName = document['first_name'];
    lastName = document['last_name'];
    mobile = document['mobile'];
    mobileVerified = document['phone_verified'];
    coupons = document['coupons'];
    if (document['home'].isNotEmpty) {
      home = DirectionModel.fromMapJson(document['home']);
    } else {
      home = null;
    }
    if (document['job'].isNotEmpty) {
      job = DirectionModel.fromMapJson(document['job']);
    } else {
      job = null;
    }
    gender = document['gender'] == 'Gender.male' ? Gender.male : Gender.female;
    email = document['email'];
    smsCode = document['sms_code'];
    smsCodeExpire = document['sms_code_expire'];
    settings = UserSettings.fromJson(document['settings']);
    referred = data.containsKey("referred") ? document['referred'] : null;
    fcmTokens = document['fcm_tokens'];
    softDelete = (document.data() as Map).containsKey('soft_delete') ? document['soft_delete'] : null;
    createdAt = document['created_at'];
    updatedAt = document['updated_at'];
  }

  Future<DriverModel?> getReferred() async {
    if (referred != null) {
      DriverModel? driverModel = await driverService.getModel(referred!);
      return driverModel;
    }
    return null;
  }
}