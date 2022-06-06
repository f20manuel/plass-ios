import 'package:get/get.dart';
import 'package:plass/models/booking.dart';
import 'package:plass/services/bookings_service.dart';

class MyTripsController extends GetxController {
  var myBookingStream = Rx<Map<String, List<BookingModel>>>({});
  var currentBookings = Rx<List<BookingModel>>([]);
  var finishedBookings = Rx<List<BookingModel>>([]);
  var canceledBookings = Rx<List<BookingModel>>([]);

  final BookingsService bookingsService = Get.find();

  @override
  void onReady() {
    super.onReady();
    myBookingStream.bindStream(bookingsService.myDocsChanges());
    ever(myBookingStream, handleMyBookings);
  }

  handleMyBookings(Map<String, List<BookingModel>> bookings) {
    currentBookings.value = bookings['current']!;
    finishedBookings.value = bookings['finished']!;
    canceledBookings.value = bookings['canceled']!;
  }

  @override
  void onClose() {
    myBookingStream.close();
    super.onClose();
  }
}