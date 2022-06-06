import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/driver.dart';

class DriverService extends GetxService {
  Future<List<DriverModel>> getApprovedDrivers() async {
    List<DriverModel> drivers = [];
    QuerySnapshot query = await Firestore
      .collection("driver")
      .where("approved", isEqualTo: true)
      .get();

    if (query.size > 0) {
      for (DocumentSnapshot document in query.docs) {
        DriverModel? driverModel = await getModel(document.id);
        if (driverModel != null) {
          drivers.add(driverModel);
        }
      }
    }
    return drivers;
  }

  Future<DriverModel?> getModel(String id) async {
    DocumentSnapshot document = await Firestore.collection('driver').doc(id).get();
    if (document.exists) {
      DriverModel driverModel = DriverModel.fromDocumentSnapshot(document);
      driverModel.rate = await calculateRate(driverModel.id!);
      return driverModel;
    }

    return null;
  }

  Future<bool> checkApprovedDriver(String id) async {
    DocumentSnapshot document = await Firestore
      .collection('driver')
      .doc(id)
      .get();

    if (document.exists) {
      return document['approved'];
    }

    return false;
  }

  Future<double> calculateRate(String id) async {
    QuerySnapshot bookings = await Firestore.collection('bookings')
      .where('driver', isEqualTo: id)
      .where('status', isEqualTo: 'finish')
      .where('customer_commented', isEqualTo: true)
      .get();

    List<Map<String, dynamic>> array = [];
    for (DocumentSnapshot document in bookings.docs) {
      Map<String, dynamic> map = document.data() as Map<String, dynamic>;
      if (map['driver_rate'] != null) {
        array.add(map);
      }
    }

    List<double> ratings = array.map((e) => double.parse(e['driver_rate'].toString())).toList();
    double sum = ratings.fold(0, (p, c) => p + c);
    if (sum > 0) {
      double average = sum / ratings.length;
      return average;
    }
    return 5.0;
  }
}