import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart' as routing;
import 'package:plass/application/theme.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/booking.dart';
import 'package:plass/models/driver.dart';
import 'package:plass/models/user_payment_method.dart';
import 'package:plass/services/bookings_service.dart';
import 'package:plass/services/drivers_service.dart';
import 'package:skeletons/skeletons.dart';

class ResumeController extends GetxController {
  Rx<BookingModel?> bookingStream = Rx<BookingModel>(Get.arguments);
  BookingModel get booking => bookingStream.value!;
  var loading = true.obs;
  var mapController = Rx<HereMapController?>(null);
  var afterMarkers = Rx<List<MapMarker>>([]);
  var afterPolyline = Rx<MapPolyline?>(null);
  var route = Rx<routing.Route?>(null);
  var rate = 3.0.obs;

  //services
  final BookingsService bookingsService = Get.find();
  final DriverService driverService = Get.find();

  final _routingEngine = routing.RoutingEngine();
  final commentController = TextEditingController();

  @override
  void onInit() {
    bookingStream.bindStream(bookingsService.docChanges(Get.arguments));
    handleBooking(bookingStream.value);
    super.onInit();
    Timer(const Duration(seconds: 2), () {
      loading.value = false;
    });
  }

  void handleBooking(BookingModel? bookingModel) async {
    try {
      if (bookingModel != null && bookingModel.driver != null && !bookingModel.customerCommented) {
        DriverModel? driverInfo = await driverService.getModel(bookingModel.driver!.id);
        if (driverInfo != null) {
          Get.defaultDialog(
              cancel: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: const BorderSide(
                            width: 4,
                            color: Palette.primary,
                          )
                      )),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Palette.primary)
                  ),
                  onPressed: Get.back,
                  child: const Text("Omitir")
              ),
              title: 'Valorar a ${driverInfo.firstName}',
              content: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: const BorderSide(
                                  color: Palette.primary,
                                  width: 4,
                                )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                width: 100,
                                height: 100,
                                imageUrl: driverInfo.avatar.isNotEmpty
                                    ? driverInfo.avatar
                                    : PlassConstants.defaultAvatar,
                                placeholder: (context, string) => SkeletonAvatar(
                                    style: SkeletonAvatarStyle(
                                        width: 100,
                                        height: 100,
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                  )
                              )
                          ),
                          const Positioned(
                              bottom: 0,
                              right: 0,
                              child: Icon(
                                Icons.verified_rounded,
                                color: Colors.white,
                                size: 36,
                              )
                          ),
                          const Positioned(
                              bottom: 4,
                              right: 4,
                              child: Icon(
                                Icons.verified_rounded,
                                color: Colors.amber,
                                size: 28,
                              )
                          )
                        ],
                      ),
                      const Divider(color: Colors.transparent),
                      RatingBar(
                          initialRating: rate.value,
                          ratingWidget: RatingWidget(
                            full: const Icon(
                                Icons.star_rounded,
                                color: Colors.orange
                            ),
                            empty: const Icon(
                                Icons.star_border_rounded,
                                color: Colors.orange
                            ),
                            half: const Icon(
                                Icons.star_half_rounded,
                                color: Colors.orange
                            ),
                          ),
                          onRatingUpdate: (value) {
                            rate.value = value;
                          }
                      ),
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(
                            top: 16,
                            bottom: 8
                        ),
                        child: const Text(
                          'Comentario:',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                            controller: commentController,
                            decoration: InputDecoration(
                                hintText: '¿Qué te pareció el viaje?',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16)
                            )
                        ),
                      ),
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(top: 16),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                    Colors.white),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100)
                                    ))
                            ),
                            onPressed: createComment,
                            child: const Text('Comentar')
                        ),
                      )
                    ],
                  )
              )
          );
        }
      }
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
    }
  }

  void createComment() async {
    try {
      await Firestore.collection('bookings').doc(booking.id!).update({
        'customer_rate': rate.value,
        'customer_comment': commentController.text,
        'customer_commented': true,
      });

      Get.back();
    } on FirebaseException catch (e) {
      Get.snackbar(e.code, e.message.toString());
    }
  }

  void onMapCreated(HereMapController controller) {
    mapController.value = controller;
    controller.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (e) {
      controller.gestures.disableDefaultAction(GestureType.doubleTap);
      controller.gestures.disableDefaultAction(GestureType.pan);
      controller.gestures.disableDefaultAction(GestureType.twoFingerPan);
      controller.gestures.disableDefaultAction(GestureType.twoFingerTap);
      List<MapMarker> markers = [];
      routing.Waypoint originWaypoint = routing.Waypoint.withDefaults(booking.pickup.coords);
      routing.Waypoint destinationWaypoint = routing.Waypoint.withDefaults(booking.drop.coords);
      MapImage destinationImage = MapImage.withFilePathAndWidthAndHeight(
          'assets/icons/drop.png',
          50,
          50
      );

      List<routing.Waypoint> waypoints = [originWaypoint, destinationWaypoint];

      _routingEngine.calculateCarRoute(
          waypoints,
          routing.CarOptions.withDefaults(),
              (routingError, routeList) async {
            if (routingError == null) {
              routing.Route _route = routeList!.first;
              route.value = _route;

              markers.add(
                  MapMarker.withAnchor(
                    _route.polyline.first,
                    MapImage.withFilePathAndWidthAndHeight(
                        'assets/icons/pickup.png', 50, 50
                    ),
                    Anchor2D.withHorizontalAndVertical(0.5, 0.5),
                  )
              );

              markers.add(
                  MapMarker.withAnchor(
                    _route.polyline.last,
                    destinationImage,
                    Anchor2D.withHorizontalAndVertical(0.5, 0.5),
                  )
              );

              controller.mapScene.removeMapMarkers(afterMarkers.value);
              controller.mapScene.addMapMarkers(markers);
              afterMarkers.value = markers;

              MapPolyline mapPolyline = MapPolyline(
                  GeoPolyline(_route.polyline),
                  8,
                  Palette.secondary
              );

              if (afterPolyline.value != null) {
                controller.mapScene.removeMapPolyline(afterPolyline.value!);
              }
              controller.mapScene.addMapPolyline(mapPolyline);
              afterPolyline.value = mapPolyline;

              controller.camera.flyToWithOptionsAndDistance(
                  _route.polyline[(_route.polyline.length / 2 - 1).round()],
                  double.parse((_route.lengthInMeters * 2.5).toString()),
                  MapCameraFlyToOptions.withDefaults()
              );
            } else {
              Get.snackbar('error', routingError.toString());
            }
          }
      );
    });
  }

  @override
  void onClose() {
    bookingStream.close();
    super.onClose();
  }
}