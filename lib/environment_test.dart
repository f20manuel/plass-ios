import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plass/environment_base.dart';

class EnvironmentTest implements EnvironmentBase {
  @override
  DocumentReference<Object?> get firestoreDB => FakeFirebaseFirestore()
      .collection('versions')
      .doc("test_version");

  @override
  String get version => "TEST";
}