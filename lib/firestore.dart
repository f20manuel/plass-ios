import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plass/environment.dart';

class Firestore {
  Firestore._();

  static CollectionReference collection(String _collection) {
    return Environment().config.firestoreDB.collection(_collection);
  }

  static final deviceInfoPlugin = DeviceInfoPlugin();
  static final fakeFirestore = FakeFirebaseFirestore();
  static void generateLog(dynamic exception, String codeData) async {
    IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    Firestore.collection('logs').add({
      'deviceInfo': {
        'name': data.name,
        'systemName': data.systemName,
        'systemVersion': data.systemVersion,
        'model': data.model,
        'localizedModel': data.localizedModel,
        'identifierForVendor': data.identifierForVendor,
        'isPhysicalDevice': data.isPhysicalDevice,
        'utsname_sysname:': data.utsname.sysname,
        'utsname_nodename:': data.utsname.nodename,
        'utsname_release:': data.utsname.release,
        'utsname_version:': data.utsname.version,
        'utsname_machine:': data.utsname.machine,
      },
      'software_version': '${packageInfo.packageName} v${packageInfo.version}',
      'user': FirebaseAuth.instance.currentUser?.uid ?? '',
      'exception': exception.toString(),
      'date': Timestamp.now(),
      'file_line': codeData,
    });
  }

  // Test section
  static CollectionReference fakeCollection(String _collection) {
    return fakeFirestore.collection('versions').doc('testing').collection(_collection);
  }
}