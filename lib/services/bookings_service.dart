import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:plass/app/data/enums/payment_method.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/booking.dart';
import 'package:plass/models/user_payment_method.dart';

import '../models/direction.dart';

class BookingsService extends GetxService {
  final auth = FirebaseAuth.instance;

  Stream<BookingModel> docChanges(BookingModel model) {
    return Firestore
      .collection('bookings')
      .doc(model.id!)
      .snapshots()
      .map((document) {
        return BookingModel.fromDocumentSnapshot(document);
      });
  }

  void checkSelectCarBooking() async {
    QuerySnapshot query = await Firestore
      .collection('bookings')
      .where('status', isEqualTo: 'select_car')
      .where('customer', isEqualTo: auth.currentUser!.uid)
      .get();

    if (query.size > 0) {
      for (DocumentSnapshot document in query.docs) {
        document.reference.delete();
      }
    }
  }

  Stream<Map<String, List<BookingModel>>> myDocsChanges() {
    List<BookingModel> current = [];
    List<BookingModel> finished = [];
    List<BookingModel> canceled = [];

    Stream<QuerySnapshot> stream = Firestore
      .collection('bookings')
      .where('customer', isEqualTo: auth.currentUser!.uid)
      .orderBy('created_at', descending: true)
      .snapshots();

    stream.listen((event) {
      if (event.docChanges.isNotEmpty) {
        current.clear();
        finished.clear();
        canceled.clear();
      }
    });

    return stream.map((query) {
      for (DocumentSnapshot document in query.docs) {
        BookingModel model = BookingModel.fromDocumentSnapshot(document);

        if (model.status == BookingStatus.finish) {
          finished.add(model);
        } else if (model.status == BookingStatus.cancel) {
          canceled.add(model);
        } else if (model.status != BookingStatus.selectCar) {
          current.add(model);
        }
      }

      return {
        'current': current.toList(),
        'finished': finished.toList(),
        'canceled': canceled.toList()
      };
    });
  }

  Stream<List<BookingModel>> inCourseDocsChanges() {
    List<BookingModel> items = [];

    Stream<QuerySnapshot> snapshots = Firestore
      .collection('bookings')
      .where('status', whereIn: ['pending', 'pickup', 'waiting', 'drop'])
      .where('customer', isEqualTo: auth.currentUser!.uid)
      .snapshots();

    snapshots.listen((event) {
      if (event.docChanges.isNotEmpty) {
        items.clear();
      }
    });

    return snapshots.map((querySnapshot) {
      for (var document in querySnapshot.docs) {
        BookingModel model = BookingModel.fromDocumentSnapshot(document);
        items.add(model);
      }

      return items.toList();
    });
  }

  Future<DocumentReference> initBookingRequest(DirectionModel origin, DirectionModel destination, String paymentMethod) async {
    Map<String, dynamic> data = {
      'customer': auth.currentUser!.uid,
      'customer_comment': '',
      'customer_commented': false,
      'customer_rate': 0.0,
      'driver': null,
      'rejected_drivers': [],
      'pickup': {
        'title': origin.title,
        'latitude': origin.coords.latitude,
        'longitude': origin.coords.longitude,
      },
      'drop':  {
        'title': destination.title,
        'latitude': destination.coords.latitude,
        'longitude': destination.coords.longitude,
      },
      'could_by_woman': false,
      'comments': [],
      'payment_method': paymentMethod,
      'trip_cost': 0,
      'car_type': null,
      'search_limit': Timestamp.now(),
      'notification_pending': false,
      'status': 'select_car',
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    };

    DocumentReference reference = await Firestore
      .collection('bookings')
      .add(data);

    return reference;
  }

  Future<BookingModel> getModel(String id) async {
    DocumentSnapshot document = await Firestore.collection('bookings').doc(id).get();
    BookingModel model = BookingModel.fromDocumentSnapshot(document);
    return model;
  }

  void setCouldByWoman(BookingModel booking, bool value) async {
    try {
      await Firestore.collection('bookings').doc(booking.id!).update({
        'could_by_woman': value,
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> removeTimeOutBookings() async {
    try {
      QuerySnapshot myBookings = await Firestore
        .collection('bookings')
        .where("status", isEqualTo: "pending")
        .where("customer", isEqualTo: auth.currentUser!.uid)
        .get();

      if (myBookings.size > 0) {
        for (var document in myBookings.docs) {
          BookingModel booking = BookingModel.fromDocumentSnapshot(document);

          if (booking.limit.compareTo(Timestamp.fromDate(DateTime.now().add(const Duration(minutes: 5)))) == -1) {
            booking.delete();
          }
        }
      }
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
    } on FirebaseException catch (exception) {
      Firestore.generateLog(exception, "Function removeTimeOutBooking => lib/services/bookings_service.dart");
    }
  }
}