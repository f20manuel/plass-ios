import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:plass/firestore.dart';
import 'package:http/http.dart' as http;

class NotificationsService extends GetxService {
  final messaging = FirebaseMessaging.instance;
  Future<NotificationSettings> requestPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings;
  }

  Future<NotificationSettings> checkPermissions() async {
    NotificationSettings settings = await messaging.getNotificationSettings();

    return settings;
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await Firestore
      .collection('users')
      .doc(userId)
      .update({
        'fcm_tokens': FieldValue.arrayUnion([token]),
      });
  }

  Future<void> sendPushNotifications(String title, String body, String token) async{
    Uri url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    Map<String, String> header = {
      'Authorization': 'key=AAAAHh9QkYk:APA91bGSK8uwUvcq4F5AVTA-Bc9EFx-BIEmWw2ri4lsUEADV4WVIhZmCzRGYF9klMi5GqGGTctGor-JDy9EuPO_t69Li-L03__LqXSArCt-eYJbMzNk79Y9WycfdU5TfXA2067iW8Qer',
      'Content-Type': 'application/json',
    };

    await http.post(url,
        headers: header,
        body: jsonEncode({
          "to": token,
          "collapse_key": "type_a",
          "notification": {
            "body": body,
            "title": title,
          },
          "data": {
            "body": "Body of Your Notification in Data",
          }
        })
    );
  }
}