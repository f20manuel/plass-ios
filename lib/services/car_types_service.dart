import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:here_sdk/routing.dart';
import 'package:plass/firestore.dart';

class CarTypesService extends GetxService {
  Future<int> getPrice(Map<String, dynamic> car, int duration, int distance) async {
    int price = 0;

    if (distance > 1 && duration > 5) {
      int minPrice = (duration * car['rate_per_minute']).round();
      int kilometerPrice = (distance * car['rate_per_kilometer']).round();

      price = minPrice + int.parse(car['rate_base'].toString()) + int.parse(car['rate_wait'].toString()) + int.parse(car['fix_quote'].toString()) + kilometerPrice;
    } else {
      price = car['min_rate'];
    }

    return roundPrice(price);
  }

  int roundPrice(int price) {
    return (price / 100).round() * 100;
  }

  Future<List<Map<String, dynamic>>> getCars(Route route) async {
    QuerySnapshot query = await Firestore.collection('car_types')
      .orderBy('position')
      .get();

      if (query.docs.isNotEmpty) {
        List<Map<String, dynamic>> data = [];
        for (DocumentSnapshot document in query.docs) {
          Map<String, dynamic> doc = document.data()! as Map<String, dynamic>;

          if (doc['name'] != 'taxi') {
            doc['price'] = await getPrice(
              doc,
              Duration(seconds: route.durationInSeconds + route.trafficDelayInSeconds).inMinutes,
              (route.lengthInMeters / 1000).round()
            );
          } else {
            doc['price'] = 0.0;
          }

          int hour = int.parse("${DateTime.now().hour}${DateTime.now().minute}");

          if (
            hour > 630 &&
            hour < 900 ||
            hour > 1700 &&
            hour < 1930 ||
            hour > 2300 &&
            hour < 400
          ) {
            doc["price"] = doc["price"] * (doc["name"] == 'max' ? 1.25 : 1.5);
          }

          data.add(doc);
        }

        return data;
      }

      return [];
  }
}