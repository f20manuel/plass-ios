import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/cupertino.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:here_sdk/core.dart';
import 'package:intl/intl.dart';
import 'package:plass/fake/helpers.dart';
import "package:plass/fake/services/bookings_service.dart";
import 'package:plass/fake/models/booking.dart';
import 'package:plass/models/driver.dart';

void main() {
  final bookingsService = FakeBookingsService();
  test("Crear booking...", () async {
    Helpers.printSeparator();
    Helpers.printAction("Creando booking...");
    Map<String, dynamic> data = {
      "customer": "test_user",
      "customer_comment": "",
      "customer_commented": false,
      "customer_rate": 0.0,
      "river": null,
      "rejected_drivers": [],
      "could_by_woman": false,
      "comments": [],
      "payment_method": "cash",
      "trip_cost": 0,
      "car_type": null,
      "search_limit": Timestamp.now(),
      "notification_pending": false,
      "status": "select_car",
      "created_at": Timestamp.now(),
      "updated_at": Timestamp.now(),
    };

    BookingModel booking = await bookingsService.add(data, doc: 'test_booking');

    expect(booking.runtimeType, BookingModel);
    expect(booking.customerComment.runtimeType, String);
    expect(booking.customerCommented, false);
    expect(booking.customerRate.runtimeType, double);
    expect(booking.couldByWoman, false);
    expect(booking.comments.runtimeType, List);
    expect(booking.carType.runtimeType, Null);
    expect(booking.limit.runtimeType, Timestamp);
    expect(booking.notificationPending, false);
    expect(booking.status, BookingStatus.selectCar);
    expect(booking.createdAt.runtimeType, Timestamp);
    expect(booking.updatedAt.runtimeType, Timestamp);

    Helpers.printDivider();
    Helpers.printData(
      "Datos del booking: \n"
      "   ID: ${booking.id} \n"
      "   Customer ID: ${booking.customer.id} \n"
      "   Servicio W: ${booking.couldByWoman.toString()} \n"
      "   Método de pago: ${booking.paymentMethod} \n"
      "   Costo: \$${NumberFormat.currency(locale: 'eu', name: '', decimalDigits: 0).format(booking.tripCost)} \n"
      "   Notificación pendiente: ${booking.notificationPending.toString()} \n"
      "   status: ${booking.status.toString()}"
    );
  });

  test("Probando los estados del Booking", () async {
    Helpers.printSeparator();
    Helpers.printAction("Cambiando booking de estado a \"Pendiente\"");
    Helpers.printDivider();
    await bookingsService.update({
      "could_by_woman": false,
      "car_type": "med",
      "estimated_time": "18 m 30 s.",
      "estimated_distance": 8000,
      "status": "pending",
      "search_limit": Timestamp.fromDate(
        DateTime.now().add(const Duration(minutes: 5))
      ),
      "trip_cost": 12000,
      "rate": 0,
    }, "test_booking");
    BookingModel? bookingModel = await bookingsService.getModel("test_booking");

    expect(bookingModel.runtimeType, BookingModel);
    expect(bookingModel?.couldByWoman, false);
    expect(bookingModel?.carType, "med");
    expect(bookingModel?.estimatedTime, "18 m 30 s.");
    expect(bookingModel?.status, BookingStatus.pending);
    expect(bookingModel?.tripCost, 12000);
    Helpers.printData(
      "Datos modificados: \n"
      "   Servicio W: ${bookingModel?.couldByWoman.toString()} \n"
      "   Car type: ${bookingModel?.carType} \n"
      "   Tiempo estimado: ${bookingModel?.estimatedTime} \n"
      "   Método de pago: ${bookingModel?.paymentMethod} \n"
      "   Costo: \$${NumberFormat.currency(locale: 'eu', name: '', decimalDigits: 0).format(bookingModel?.tripCost)} \n"
      "   Status: ${bookingModel?.status.toString()} \n"
      "   Límite de búsqueda: ${DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.fromMicrosecondsSinceEpoch(bookingModel?.limit.microsecondsSinceEpoch ?? 0))}"
    );

    Helpers.printSeparator();
    Helpers.printAction("Cambiando booking de estado a \"Waiting\"");
    Helpers.printDivider();
    await bookingsService.update({
      "status": "waiting",
      "driver": "test_driver",
      "search_limit": Timestamp.fromDate(
          DateTime.now().add(const Duration(minutes: 5))
      ),
    }, "test_booking");
    bookingModel = await bookingsService.getModel("test_booking");

    expect(bookingModel.runtimeType, BookingModel);
    expect(bookingModel?.status, BookingStatus.waiting);
    Helpers.printData(
        "Datos modificados: \n"
        "   Status: ${bookingModel?.status.toString()}"
    );

    Helpers.printSeparator();
    Helpers.printAction("Cambiando booking de estado a \"Pickcup\"");
    Helpers.printDivider();
    await bookingsService.update({
      "status": "pickup"
    }, "test_booking");
    bookingModel = await bookingsService.getModel("test_booking");
    DriverModel? driverModel = await bookingModel?.getDriverInfo();

    expect(bookingModel.runtimeType, BookingModel);
    expect(bookingModel?.status, BookingStatus.pickup);
    Helpers.printData(
      "Datos modificados: \n"
      "   Status: ${bookingModel?.status.toString()}"
    );

    Helpers.printSeparator();
    Helpers.printAction("Cambiando booking de estado a \"Drop\"");
    Helpers.printDivider();
    await bookingsService.update({
      "status": "drop"
    }, "test_booking");
    bookingModel = await bookingsService.getModel("test_booking");

    expect(bookingModel.runtimeType, BookingModel);
    expect(bookingModel?.status, BookingStatus.drop);
    Helpers.printData(
      "Datos modificados: \n"

      "   Status: ${bookingModel?.status.toString()}"
    );

    Helpers.printSeparator();
    Helpers.printAction("Cambiando booking de estado a \"Finish\"");
    Helpers.printDivider();
    await bookingsService.update({
      "status": "finish"
    }, "test_booking");
    bookingModel = await bookingsService.getModel("test_booking");

    expect(bookingModel.runtimeType, BookingModel);
    expect(bookingModel?.status, BookingStatus.finish);
    Helpers.printData(
      "Datos modificados: \n"
      "   Status: ${bookingModel?.status.toString()}"
    );
  });
}