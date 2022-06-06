import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plass/environment_base.dart';

class EnvironmentPro implements EnvironmentBase {
  @override
  DocumentReference<Object?> get firestoreDB => FirebaseFirestore
    .instance
    .collection('versions')
    .doc("1.0.0");

  @override
  String get version => "PRO";
}