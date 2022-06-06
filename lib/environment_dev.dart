import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plass/environment_base.dart';

class EnvironmentDev implements EnvironmentBase {
  @override
  DocumentReference<Object?> get firestoreDB => FirebaseFirestore
      .instance
      .collection('versions')
      .doc("dev_version");

  @override
  String get version => "DEV";
}