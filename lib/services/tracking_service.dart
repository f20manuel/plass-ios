import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/booking.dart';
import 'package:plass/models/tracking.dart';

class TrackingService extends GetxService {
  Stream<List<TrackingModel>> trackingListChanges() {
    List<TrackingModel> list = [];
    Stream<QuerySnapshot> query = Firestore.collection('tracking').snapshots();

    query.listen((event) {
      if (event.docChanges.isNotEmpty) {
        list.clear();
      }
    });

    return query.map((querySnapshot) {
      for (var document in querySnapshot.docs) {
        if (
          document['position']['heading'] != null ||
          document['position']['latitude'] != null ||
          document['position']['longitude'] != null ||
          document['position']['speed'] != null
        ) {
          TrackingModel model = TrackingModel.fromDocumentSnapshot(document);
          list.add(model);
        }
      }

      return list.toList();
    });
  }

  Stream<TrackingModel?> trackingChanges(BookingModel? model) {
    TrackingModel? tracking;

    if (model == null) return Stream.value(tracking);

    if (model.status != BookingStatus.pickup && model.status != BookingStatus.drop) {
      Stream.value(tracking);
    }

    if (model.driver == null) return Stream.value(null);

    Stream<DocumentSnapshot> query = Firestore.collection('tracking').doc(model.driver!.id).snapshots();

    return query.map((document) {
      tracking = TrackingModel.fromDocumentSnapshot(document);
      return tracking;
    });
  }
}