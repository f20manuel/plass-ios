import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart' as routing;
import 'package:here_sdk/search.dart';
import 'package:plass/app/data/enums/payment_method.dart';
import 'package:plass/app/data/providers/firestore.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/booking.dart';
import 'package:plass/models/direction.dart';
import 'package:plass/models/driver.dart';
import 'package:plass/models/message.dart';
import 'package:plass/models/search.dart';
import 'package:plass/models/tracking.dart';
import 'package:plass/models/user_payment_method.dart';
import 'package:plass/my_trips/my_trips_binding.dart';
import 'package:plass/my_trips/my_trips_page.dart';
import 'package:plass/notifications_dialog/notifications_dialog_binding.dart';
import 'package:plass/notifications_dialog/notifications_dialog_page.dart';
import 'package:plass/other_location_dialog/other_location_page.dart';
import 'package:plass/payments/payment_binding.dart';
import 'package:plass/payments/payment_page.dart';
import 'package:plass/resume/resume_binding.dart';
import 'package:plass/resume/resume_page.dart';
import 'package:plass/search_booking/search_binding.dart';
import 'package:plass/search_booking/search_controller.dart';
import 'package:plass/search_booking/search_page.dart';
import 'package:plass/services/bookings_service.dart';
import 'package:plass/services/car_types_service.dart';
import 'package:plass/services/chats_service.dart';
import 'package:plass/services/drivers_service.dart';
import 'package:plass/services/here_service.dart';
import 'package:plass/services/notifications_service.dart';
import 'package:plass/services/tracking_service.dart';
import 'package:plass/widgets/plass_swipe_button/plass_swipe_button_controller.dart';

class HomeController extends GetxController {
  // Streams
  var engoingBookings = Rx<List<BookingModel>>([]);
  var booking = Rx<BookingModel?>(null);
  var trackings = Rx<List<TrackingModel>>([]);
  var tracking = Rx<TrackingModel?>(null);
  var messages = Rx<List<MessageModel>>([]);

  // Stream Subscription
  late StreamSubscription trackingsSubscription;
  late StreamSubscription bookingSubscription;
  late StreamSubscription trackingSubscription;
  late StreamSubscription messagesSubscription;
  StreamSubscription? handleMyPositionSubscription;
  StreamSubscription? handleTrackingsSubscription;
  StreamSubscription? handleBookingSubscription;
  StreamSubscription? handleTrackingSubscription;
  StreamSubscription? handleMessagesSubscription;
  StreamSubscription? handlePaymentMethodSubscription;

  // Variables
  var timerMap = Rx<Timer?>(null);
  var loading = true.obs;
  var haveRides = false.obs;
  var myPosition = Rx<GeoCoordinates?>(null);
  var afterPolyline = Rx<MapPolyline?>(null);
  var afterIndicators = <TrackingModel>[].obs;
  var afterMarkers = <MapMarker>[].obs;
  var mapController = Rx<HereMapController?>(null);
  var afterMarker = Rx<MapMarker?>(null);
  var origin = Rx<DirectionModel?>(null);
  var destination = Rx<DirectionModel?>(null);
  var closeSweetBottom = false.obs;
  var searchButtonOpacity = 1.0.obs;
  var route = Rx<routing.Route?>(null);
  //on select car
  var selectCarHeight = 0.obs;
  var persistenceSelectCarHeight = 456.obs;
  var selectedCar = {}.obs;
  var loadingCars = true.obs;
  var cars = [].obs;
  var payment = Rx<UserPaymentMethodModel?>(null);
  //on pending
  var pendingHeight = 0.obs;
  var persistencePendingHeight = 300.obs;
  var timer = 0.obs;
  var timerPeriodic = Rx<Timer?>(null);
  var loadingPanel = true.obs;
  //on pickup or on drop
  var animateCamera = true.obs;
  var pickupHeight = 0.obs;
  var persistencePickupHeight = 280.obs;
  var maxPickupHeight = 500.obs;
  var driverIndicator = Rx<LocationIndicator?>(null);
  var estimateTime = 0.obs;
  var haveChats = false.obs;
  var loadingDriverInfo = true.obs;

  var closeNotification = false.obs;

  // select on map variables
  var isSelectMap = false.obs;
  var selectMapBannerOpacity = 0.0.obs;
  var isFocusOrigin = false.obs;

  final HereService hereService = Get.find();
  final BookingsService bookingsService = Get.find();
  final TrackingService trackingService = Get.find();
  final CarTypesService carTypesService = Get.find();
  final DriverService driverService = Get.find();
  final ChatsService chatsService = Get.find();
  final NotificationsService notificationsService = Get.find();
  final PlassSwipeButtonController plassSwipeButtonController = Get.find();
  final AppController app = Get.find();
  final searchEngine = SearchEngine();
  final routingEngine = routing.RoutingEngine();

  @override
  void onInit() {
    engoingBookings.bindStream(bookingsService.inCourseDocsChanges());
    trackingsSubscription     = trackings.stream.listen(setMarkers);
    bookingSubscription       = booking.stream.listen(handleBooking);
    trackingSubscription      = tracking.stream.listen(handleTracking);
    messagesSubscription      = messages.stream.listen(handleChat);
    timerMap.value            = Timer.periodic(
      const Duration(minutes: 20),
      (timer) {
        ccurrentLocation();
      }
    );
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // bookingsService.removeTimeOutBookings();
    bookingsService.checkSelectCarBooking();
    checkNotificationsPermissions();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void startTrackingsSubscription() {
    if (app.connectivityResult.value != ConnectivityResult.none) {
      handleTrackingsSubscription =
          Firestore.collection('tracking').snapshots().listen((event) {
            List<TrackingModel> _trackings = [];
            if (event.docChanges.isNotEmpty) {
              _trackings.clear();
            }

            for (var document in event.docs) {
              if (
                document['position']['heading'] != null ||
                document['position']['latitude'] != null ||
                document['position']['longitude'] != null ||
                document['position']['speed'] != null
              ) {
                TrackingModel model = TrackingModel.fromDocumentSnapshot(
                    document
                );
                _trackings.add(model);
              }
            }

            trackings.value = _trackings;
          });
      return;
    }

    PlassConstants.notNetworkMessage();
  }

  void openPaymentMethod() {
    Get.to(() => const PaymentPage(), binding: PaymentBinding());
  }

  void startTrackingAndMessagesSubscription(BookingModel bookingModel) {
    if (app.connectivityResult.value != ConnectivityResult.none) {
      handleMessagesSubscription = Firestore.collection('chats')
          .doc('${bookingModel.driver!.id}-${bookingModel.customer.id}-${bookingModel.id}')
          .snapshots()
          .listen((document) {
        List<MessageModel> models = [];
        if (document['messages'].isNotEmpty) {
          for (Map message in document['messages']) {
            MessageModel model = MessageModel.fromMap(message);
            models.add(model);
          }
        }

        messages.value = models;
      });

      handleTrackingSubscription = Firestore.collection('tracking')
        .doc(bookingModel.driver!.id).snapshots().listen((document) {
          if (
            document['position']['heading'] != null ||
            document['position']['latitude'] != null ||
            document['position']['longitude'] != null ||
            document['position']['speed'] != null
          ) {
            TrackingModel model = TrackingModel.fromDocumentSnapshot(document);
            tracking.value = model;
          }
        });

      return;
    }

    PlassConstants.notNetworkMessage();
  }

  checkNotificationsPermissions() async {
    NotificationSettings settings = await notificationsService.checkPermissions();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await FirebaseMessaging.instance.getToken();
      // Save the initial token to the database
      await notificationsService.saveTokenToDatabase(token!);
      // Any time the token refreshes, store this in the database too.
      FirebaseMessaging.instance.onTokenRefresh.listen(
        notificationsService.saveTokenToDatabase
      );
    } else if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      await Get.to(() => const NotificationsDialogPage(), binding: NotificationsDialogBinding());
      Timer(const Duration(seconds: 1), () => checkNotificationsPermissions());
    }
  }

  setMarkers(List<TrackingModel> trackings) async {
    if (mapController.value != null) {
      // Si un booking esta seleccionado, borrar todos los indicadores
      if (booking.value != null) {
        if (afterIndicators.isNotEmpty) {
          for (TrackingModel tracking in afterIndicators) {
            tracking.indicator.disable();
            mapController.value!.removeLifecycleListener(tracking.indicator);
          }
          afterIndicators.clear();
        }
        return;
      }

      List<TrackingModel> indicators = [];
      // Traer los tracking
      if (trackings.isNotEmpty) {
        for (TrackingModel? tracking in trackings) {
          if (tracking != null) {
            if (myPosition.value != null) {
              if (
                // tracking.position.coords.distanceTo(myPosition.value!) < 3000 &&
                tracking.position.coords.distanceTo(myPosition.value!) > 50
              ) {
                DriverModel? driver = await driverService.getModel(
                  tracking.userUid
                );
                if (driver != null) {
                  if (driver.approved) {
                    indicators.add(tracking);
                  }
                }
              }
            } else {
              DriverModel? driver = await driverService.getModel(
                  tracking.userUid
              );
              if (driver != null) {
                if (driver.approved) {
                  indicators.add(tracking);
                }
              }
            }
          }
        }

        MapMarker3DModel mapMarker3DModel = MapMarker3DModel.withTextureFilePath(
          'assets/3d/plane.obj', 'assets/icons/cars/standar.png'
        );

        if (afterIndicators.isNotEmpty) {
          for (TrackingModel tracking in afterIndicators) {
            Location location = Location.withCoordinates(tracking.position.coords);
            location.time = DateTime.now();
            location.bearingInDegrees = tracking.position.heading.toDouble();
            tracking.indicator.setMarker3dModel(
              mapMarker3DModel,
              15,
              LocationIndicatorMarkerType.navigation
            );
            tracking.indicator.updateLocation(location);
          }
        } else {
          for (TrackingModel tracking in indicators) {
            Location location = Location.withCoordinates(
              tracking.position.coords
            );
            location.time = DateTime.now();
            location.bearingInDegrees = tracking.position.heading.toDouble();
            tracking.indicator.setMarker3dModel(
              mapMarker3DModel,
              15,
              LocationIndicatorMarkerType.navigation
            );
            tracking.indicator.updateLocation(location);
            mapController.value!.addLifecycleListener(tracking.indicator);
            afterIndicators.add(tracking);
          }
        }
      }
    }
  }

  onMapCreated(HereMapController controller) {
    mapController.value ??= controller;
    controller.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (error) {
      if (error != null) {
        Firestore.generateLog(
            error, 'function onMapCreated -> lib/home/home_controller.dart');
      }
      getMyLocation();
    });
  }

  void ccurrentLocation() async {
    loading.value = true;
    if (mapController.value != null && myPosition.value != null) {
      if (booking.value != null && route.value != null) {
        MapCameraFlyToOptions options = MapCameraFlyToOptions.withDefaults();
        options.duration = const Duration(milliseconds: 500);
        mapController.value!.camera.flyToWithOptionsAndDistance(
          route.value!.polyline[(route.value!.polyline.length / 2 - 1).round()],
          double.parse((route.value!.lengthInMeters * 2.5).toString()),
          options
        );
        loading.value = false;
        return;
      }
      MapCameraFlyToOptions options = MapCameraFlyToOptions.withDefaults();
      options.duration = const Duration(milliseconds: 500);

      mapController.value!.camera.flyToWithOptionsAndDistance(
        myPosition.value!, 1000, options,
      );
      MapMarker myMarker = MapMarker.withAnchor(
          myPosition.value!,
          MapImage.withFilePathAndWidthAndHeight(
            'assets/icons/pickup.png',
            50,
            50,
          ),
          Anchor2D.withHorizontalAndVertical(0.5, 0.5)
      );

      if (afterMarker.value != null) {
        mapController.value!.mapScene.removeMapMarker(afterMarker.value!);
      }
      mapController.value!.mapScene.addMapMarker(myMarker);

      afterMarker.value = myMarker;
    }
    loading.value = false;
  }

  getMyLocation() async {
    try {
      GeoCoordinates? myLocation = await hereService.getMyLocation();
      myPosition.value = myLocation;
      if (mapController.value != null && myLocation != null) {
        if (booking.value != null && route.value != null) {
          MapCameraFlyToOptions options = MapCameraFlyToOptions.withDefaults();
          options.duration = const Duration(milliseconds: 500);
          mapController.value!.camera.flyToWithOptionsAndDistance(
            route.value!.polyline[(route.value!.polyline.length / 2 - 1).round()],
            double.parse((route.value!.lengthInMeters * 2.5).toString()),
            options
          );
          return;
        }
        destination.value = null;
        MapCameraFlyToOptions options = MapCameraFlyToOptions.withDefaults();
        options.duration = const Duration(milliseconds: 500);

        mapController.value!.camera.flyToWithOptionsAndDistance(
          myLocation, 1000, options,
        );
        MapMarker myMarker = MapMarker.withAnchor(
          myLocation,
          MapImage.withFilePathAndWidthAndHeight(
            'assets/icons/pickup.png',
            50,
            50,
          ),
          Anchor2D.withHorizontalAndVertical(0.5, 0.5)
        );

        if (afterMarker.value != null) {
          mapController.value!.mapScene.removeMapMarker(afterMarker.value!);
        }
        mapController.value!.mapScene.addMapMarker(myMarker);

        afterMarker.value = myMarker;

        SearchOptions searchOptions = SearchOptions.withDefaults();
        searchOptions.languageCode = LanguageCode.esEs;
        searchOptions.maxItems = 5;

        searchEngine.searchByCoordinates(
          myLocation,
          searchOptions,
          (error, places) {
            if (error != null) {
              Firestore.generateLog(error, 'Line 136 in lib/home/home_controller.dart');
            }

            if (places![0].address.country != 'Colombia') {
              Get.offAll(() => const OtherLocationPage());
              return;
            }

            origin.value = DirectionModel(
              title: places[0].address.addressText.split(',')[0],
              coords: myLocation
            );
          }
        );
        loading.value = false;
        // handleMyPositionSubscription ??= hereService
        // .location.onLocationChanged.listen((currentLocation) {
        //   if (
        //     currentLocation.altitude != null &&
        //     currentLocation.longitude != null
        //   ) {
        //     GeoCoordinates coords = GeoCoordinates(
        //         currentLocation.latitude!, currentLocation.longitude!
        //     );
        //
        //     myPosition.value = coords;
        //   }
        // });
        if (handleTrackingsSubscription == null) {
          // startTrackingsSubscription();
        }
        return;
      }
      MapCameraFlyToOptions options = MapCameraFlyToOptions.withDefaults();
      options.duration = const Duration(milliseconds: 500);

      mapController.value!.camera.flyToWithOptionsAndDistance(
        GeoCoordinates(4.6759055,-74.0417513), 300000, options,
      );
      loading.value = false;
    } on SocketException catch (_) {
      Get.snackbar('¡Oops!', '¡Su conexión a internet ha fallado!');
      return null;
    } catch (e) {
      Firestore.generateLog(e, 'Line 12 in lib/services/here_service.dart');
      return null;
    }
  }

  removeDriverIndicator() {
    if (driverIndicator.value != null) {
      driverIndicator.value!.disable();
      mapController.value?.removeLifecycleListener(
        driverIndicator.value!
      );
      handleTrackingSubscription?.cancel();
      handleMessagesSubscription?.cancel();
      driverIndicator.value = null;
      tracking.value = null;
      messages.value.clear();
    }
  }

  removeIndicators() {
    if (afterIndicators.isNotEmpty) {
      for (TrackingModel tracking in afterIndicators) {
        tracking.indicator.disable();
        mapController.value!.removeLifecycleListener(tracking.indicator);
      }
      trackings.value.clear();
      handleTrackingsSubscription?.cancel();
      handleTrackingsSubscription = null;
      afterIndicators.clear();
    }
  }

  removePolyline() {
    if (afterPolyline.value != null) {
      mapController.value?.mapScene.removeMapPolyline(afterPolyline.value!);
      afterPolyline.value = null;
    }
  }

  removeMarkers() {
    if (afterMarker.value != null) {
      mapController.value?.mapScene.removeMapMarker(afterMarker.value!);
      afterMarker.value = null;
    }

    mapController.value?.mapScene.removeMapMarkers(afterMarkers);
    afterMarkers.clear();
  }

  checkAndInitBooking(DirectionModel? origin, DirectionModel? destination) async {
    try {
      if (app.connectivityResult.value != ConnectivityResult.none) {
        if (origin != null && destination != null) {
          DocumentReference reference = await bookingsService
              .initBookingRequest(origin, destination, paymentMethodTypeEnglish(payment.value?.name ?? 'cash'));
          handleBookingSubscription =
            Firestore.collection("bookings").doc(reference.id)
              .snapshots()
              .listen((document) {
                booking.value = BookingModel.fromDocumentSnapshot(document);
              }
            );
          return;
        }

        goToSearch();
        return;
      }

      PlassConstants.notNetworkMessage();
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
    } on FirebaseException catch (exception) {
      Firestore.generateLog(
        exception,
        'line 160 in lib/home/home_controller.dart'
      );
    }
  }

  handleBooking(BookingModel? bookingModel) async {
    removeIndicators();
    removeMarkers();
    removePolyline();
    removeDriverIndicator();
    if (mapController.value != null) {
      if (bookingModel != null) {
        selectCarHeight.value = 0;
        destination.value = null;
        searchButtonOpacity.value = 0;
        selectMapBannerOpacity.value = 0;
        isSelectMap.value = false;
        pendingHeight.value = 0;
        loadingDriverInfo.value = true;
        animateCamera.value = true;
        if (timerPeriodic.value != null) {
          timerPeriodic.value!.cancel();
        }
        if (bookingModel.status == BookingStatus.selectCar) {
          selectCarHeight.value = 456;
          handlePaymentMethodSubscription ??= Collection.userPaymentMethods
          .where('user_uid', isEqualTo: app.userInfo.id)
          .snapshots()
          .listen((event) {
            if (event.docs.isNotEmpty) {
              for (DocumentSnapshot document in event.docs) {
                UserPaymentMethodModel _paymentMethod = UserPaymentMethodModel
                    .fromDocumentSnapshot(document);
                if (_paymentMethod.active) {
                  payment.value = _paymentMethod;
                }
              }
            }
          });

          getRoute(bookingModel);
          return;
        } else if (bookingModel.status == BookingStatus.pending) {
          Timer.periodic(const Duration(seconds: 1), (_timer) {
            int time = bookingModel.limit.millisecondsSinceEpoch - Timestamp
              .now()
              .millisecondsSinceEpoch;
            if (time > 0) {
              timer.value = time;
              pendingHeight.value = 320;
              persistencePendingHeight.value = 320;
              loadingPanel.value = false;
              timerPeriodic.value = _timer;
            } else {
              _timer.cancel();
              pendingHeight.value = 300;
              persistencePendingHeight.value = 300;
              loadingPanel.value = false;
            }
          });
          getRoute(bookingModel);
          await bookingModel.sendNotificationPending();
          return;
        } else if (
          bookingModel.status == BookingStatus.waiting ||
          bookingModel.status == BookingStatus.pickup ||
          bookingModel.status == BookingStatus.drop
        ) {
          pickupHeight.value = 280;
          tracking.value = null;
          messages.value.clear();
          if (bookingModel.driver != null) {
            startTrackingAndMessagesSubscription(bookingModel);
            Timer(const Duration(seconds: 2), () {
              ccurrentLocation();
            });
          }
          if (bookingModel.status == BookingStatus.waiting) {
            Timer.periodic(const Duration(seconds: 1), (_timer) {
              int time = bookingModel.limit.millisecondsSinceEpoch - Timestamp
                  .now()
                  .millisecondsSinceEpoch;
              if (time > 0) {
                timer.value = time;
                timerPeriodic.value = _timer;
              } else {
                _timer.cancel();
              }
            });
          }
          return;
        } else if (bookingModel.status == BookingStatus.cancel) {
          goToHomeState();
          return;
        } else if (bookingModel.status == BookingStatus.finish) {
          goToHomeState();
          Get.to(
            () => const ResumePage(),
            binding: ResumeBinding(),
            arguments: bookingModel
          );
          return;
        }
        goToHomeState();
        return;
      }
    }
    goToHomeState();
    return;
  }

  handleChat(List<MessageModel> messages) {
    haveChats.value = false;
    bool validateNewMessage = messages.isNotEmpty && messages.last.from == "driver" && messages.last.status == "pending";
    if (validateNewMessage) {
      FlutterRingtonePlayer.play(
        android: AndroidSounds.notification,
        ios: IosSounds.glass,
      );

      haveChats.value = true;
    }
  }

  goToHomeState({bool nullDirections = true}) {
    // bing streams
    loading.value = true;
    myPosition = Rx<GeoCoordinates?>(null);
    if (nullDirections) {
      destination = Rx<DirectionModel?>(null);
    }

    // booking selectCar variables
    selectCarHeight.value = 0;
    selectedCar.value = {};
    loadingCars.value = true;
    cars.value = [];

    // booking pending variables
    pendingHeight.value = 0;
    timer.value = 0;
    timerPeriodic = Rx<Timer?>(null);
    loadingPanel.value = true;

    // booking pickup or drop
    pickupHeight.value = 0;
    estimateTime.value = 0;
    haveChats.value = false;
    loadingDriverInfo.value = false;

    searchButtonOpacity.value = 1.0;
    selectMapBannerOpacity.value = 0.0;
    plassSwipeButtonController.active.value = false;
    plassSwipeButtonController.left.value = null;
    plassSwipeButtonController.right.value = null;

    if (mapController.value != null) {
      mapController.value!.gestures.panListener = null;
      getMyLocation();
      // mapController.value!.finalize();
      // onMapCreated(mapController.value!);
    }

    booking.value = null;
    handleBookingSubscription?.cancel();
    tracking.value = null;
    handleTrackingSubscription?.cancel();
    handleMessagesSubscription?.cancel();

    removePolyline();
    removeDriverIndicator();
    removeMarkers();
    // if (handleTrackingsSubscription != null && handleTrackingsSubscription!.isPaused) {
    //   handleTrackingsSubscription.reactive();
    // }
    update();
  }

  goToCurrentBookings() async {
    if (app.connectivityResult.value != ConnectivityResult.none) {
      BookingModel? bookingModel = await Get.to(() => const MyTripsPage(),
          binding: MyTripsBinding());
      if (bookingModel != null) {
        handleBookingSubscription =
          Firestore.collection("bookings").doc(bookingModel.id)
          .snapshots()
          .listen(
            (document) {
              booking.value = BookingModel.fromDocumentSnapshot(document);
            }
          );
        return;
      } else {
        booking.value = null;
      }

      return;
    }

    PlassConstants.notNetworkMessage();
  }

  goToSearch() async {
    if (app.connectivityResult.value != ConnectivityResult.none) {
      ccurrentLocation();
      SearchModel? searchModel = await Get.to(
        const SearchPage(),
        binding: SearchBinding(),
        transition: Transition.downToUp,
        fullscreenDialog: true,
        arguments: SearchArguments(
          origin: origin.value,
          destination: destination.value,
        )
      );

      if (searchModel != null) {
        isSelectMap.value = searchModel.isSelectMap ?? false;
        isFocusOrigin.value = searchModel.focusOrigin ?? false;
        origin.value = searchModel.origin ?? origin.value;
        destination.value = searchModel.destination ?? destination.value;

        // checkAndInitBooking(searchModel.origin, searchModel.destination);
        if (searchModel.isSelectMap != null && mapController.value != null) {
          selectMapBannerOpacity.value = 1.0;
          searchButtonOpacity.value = 0.0;
          mapController.value!.gestures.panListener =
          PanListener((state, x, y, valor) {
            if (state.name == 'end') {
              onMoveCamera(mapController.value!.camera.state);
            }
          });
        }
      }
      return;
    }
    PlassConstants.notNetworkMessage();
  }

  modifySearch() async {
    if (app.connectivityResult.value != ConnectivityResult.none) {
      if (booking.value != null) {
        origin.value = booking.value!.pickup;
        destination.value = booking.value!.drop;
        Firestore.collection('bookings').doc(booking.value!.id).delete();
        goToHomeState(nullDirections: false);
      }

      goToSearch();
      return;
    }

    PlassConstants.notNetworkMessage();
  }

  getRoute(BookingModel bookingModel) async {
    if (mapController.value != null) {
      List<MapMarker> markers = [];
      routing.Waypoint originWaypoint = routing.Waypoint.withDefaults(
          bookingModel.pickup.coords);
      routing.Waypoint destinationWaypoint = routing.Waypoint.withDefaults(
          bookingModel.drop.coords);
      MapImage originImage = MapImage.withFilePathAndWidthAndHeight(
          'assets/icons/pickup.png', 50, 50
      );
      MapImage destinationImage = MapImage.withFilePathAndWidthAndHeight(
          'assets/icons/drop.png',
          50,
          50
      );

      List<routing.Waypoint> waypoints = [originWaypoint, destinationWaypoint];
      routingEngine.calculateCarRoute(
        waypoints,
        routing.CarOptions.withDefaults(),
            (routingError, routeList) async {
          if (routingError == null) {
            routing.Route _route = routeList!.first;
            route.value = _route;

            cars.value = await carTypesService.getCars(_route);
            loadingCars.value = false;

            markers.add(
              MapMarker.withAnchor(
                _route.polyline.first,
                originImage,
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

            mapController.value!.mapScene.removeMapMarkers(afterMarkers);
            mapController.value!.mapScene.addMapMarkers(markers);
            afterMarkers.value = markers;

            MapPolyline mapPolyline = MapPolyline(
                GeoPolyline(_route.polyline),
                4,
                Palette.secondary
            );

            removePolyline();
            mapController.value!.mapScene.addMapPolyline(mapPolyline);
            afterPolyline.value = mapPolyline;

// print(_route.lengthInMeters / 1000);
// print(Duration(seconds: _route.durationInSeconds + _route.trafficDelayInSeconds).inMinutes.toString());
            MapCameraFlyToOptions cameraOptions = MapCameraFlyToOptions.withDefaults();
            cameraOptions.duration = const Duration(milliseconds: 500);

            mapController.value!.camera.flyToWithOptionsAndDistance(
              _route.polyline[(_route.polyline.length / 2 - 1).round()],
              double.parse((_route.lengthInMeters * 2.5).toString()),
              cameraOptions
            );
          }
        }
      );
    }
  }

  requestBooking() async {
    if (app.connectivityResult.value != ConnectivityResult.none) {
      try {
        if (booking.value != null) {
          Map<String, dynamic> requestData = {
            'could_by_woman': booking.value!.couldByWoman,
            'car_type': selectedCar['name'],
            'estimated_time': "${Duration(seconds: route.value!.durationInSeconds +
              route.value!.trafficDelayInSeconds).inMinutes} m ${((route.value!.durationInSeconds +
              route.value!.trafficDelayInSeconds)%60).toString().padLeft(2, '0')} s.",
            'estimated_distance': (route.value!.lengthInMeters / 1000).round(),
            'status': 'pending',
            'payment_method': paymentMethodTypeEnglish(payment.value?.name ?? 'cash'),
            'search_limit': Timestamp.fromDate(
              DateTime.now().add(const Duration(minutes: 5))
            ),
            'trip_cost': selectedCar['name'] == 'taxi' ? 0 : selectedCar['price'],
            'rate': 0,
          };

          await Firestore.collection('bookings').doc(booking.value!.id!).update(
            requestData
          );
        }
      } on SocketException catch (_) {
        PlassConstants.notNetworkMessage();
      } catch (exception) {
        Firestore.generateLog(exception, 'Line 345 in lib/home/home_controller.dart');
      }
      return;
    }

    PlassConstants.notNetworkMessage();
  }

  //pickup state
  handleTracking(TrackingModel? trackingModel) {
    if (booking.value != null && trackingModel != null) {
      if (booking.value!.status == BookingStatus.pickup || booking.value!.status == BookingStatus.drop || booking.value!.status == BookingStatus.waiting) {
        getPickupAndDropRoute(booking.value!, trackingModel);
      }
    }
  }

  getPickupAndDropRoute(BookingModel bookingModel, TrackingModel trackingModel) {
    if (mapController.value != null) {
      List<MapMarker> markers = [];
      routing.Waypoint originWaypoint = routing.Waypoint.withDefaults(
        trackingModel.position.coords
      );
      routing.Waypoint destinationWaypoint = routing.Waypoint.withDefaults(
        bookingModel.pickup.coords
      );
      MapImage destinationImage = MapImage.withFilePathAndWidthAndHeight(
        'assets/icons/pickup.png',
        50,
        50
      );

      if (
        bookingModel.status == BookingStatus.waiting ||
        bookingModel.status == BookingStatus.drop
      ) {
        destinationWaypoint = routing.Waypoint.withDefaults(
            bookingModel.drop.coords
        );
        destinationImage = MapImage.withFilePathAndWidthAndHeight(
          'assets/icons/drop.png',
          50,
          50
        );
      }

      List<routing.Waypoint> waypoints = [originWaypoint, destinationWaypoint];
      routingEngine.calculateCarRoute(
          waypoints,
          routing.CarOptions.withDefaults(),
              (routingError, routeList) async {
            if (routingError == null) {
              routing.Route _route = routeList!.first;
              route.value = _route;

              estimateTime.value = _route.durationInSeconds;
              if (_route.polyline.first.distanceTo(_route.polyline.last) < 500 && closeNotification.isFalse) {
                String driver = bookingModel.couldByWoman ? "afiliada" : "afiliado";
                if (bookingModel.status == BookingStatus.pickup) {
                  Get.snackbar(
                    "Tu $driver esta Cerca",
                    "Tu $driver esta a menos de 500m.",
                    backgroundColor: Colors.white,
                    duration: const Duration(seconds: 5),
                  );
                } else {
                  Get.snackbar(
                    "Ya casi llegas",
                    "Estas a punto de llegar a tu punto de destino, por favor verifique no dejar nada olvidado dentro del vehículo.",
                    backgroundColor: Colors.white,
                    duration: const Duration(seconds: 5),
                  );
                }
                closeNotification.value = true;
              } else if (_route.polyline.first.distanceTo(_route.polyline.last) > 500 && closeNotification.isTrue) {
                closeNotification.value = false;
              }

              removeMarkers();

              MapMarker3DModel mapMarker3DModel = MapMarker3DModel.withTextureFilePath(
                'assets/3d/plane.obj', 'assets/icons/cars/standar.png'
              );

              removeIndicators();

              var locationIndicator = LocationIndicator();
              Location location = Location.withCoordinates(
                _route.polyline.first
              );
              location.bearingInDegrees = double.parse(
                trackingModel.position.heading.toString()
              );
              locationIndicator.setMarker3dModel(
                mapMarker3DModel,
                15,
                LocationIndicatorMarkerType.navigation
              );
              if (mapController.value != null) {
                if (driverIndicator.value == null) {
                  locationIndicator.updateLocation(location);
                  mapController.value!.addLifecycleListener(locationIndicator);
                  driverIndicator.value = locationIndicator;
                } else {
                  driverIndicator.value!.updateLocation(location);
                }

                markers.add(MapMarker.withAnchor(
                  _route.polyline.last,
                  destinationImage,
                  Anchor2D.withHorizontalAndVertical(0.5, 0.5),
                ));

                mapController.value!.mapScene.addMapMarker(markers.first);
                mapController.value!.mapScene.removeMapMarkers(afterMarkers);
                afterMarkers.value = markers;

                MapPolyline mapPolyline = MapPolyline(
                  GeoPolyline(_route.polyline),
                  4,
                  Palette.secondary
                );
                removePolyline();
                mapController.value!.mapScene.addMapPolyline(mapPolyline);
                afterPolyline.value = mapPolyline;

                if (driverIndicator.value == null) {
                  mapController.value!.camera.flyToWithOptionsAndDistance(
                    _route.polyline[(_route.polyline.length / 2 - 1).round()],
                    double.parse((_route.lengthInMeters * 2.5).toString()),
                    MapCameraFlyToOptions.withDefaults()
                  );
                }
              }
            }
          }
      );
    }
  }

  //booking timer
  initTimer(BookingModel booking) {
    Firestore.collection('bookings').doc(booking.id!).update({
      'search_limit': Timestamp.fromDate(DateTime.now().add(const Duration(minutes: 5)))
    });

    Timer.periodic(const Duration(seconds: 1), (_timer) {
      int time = booking.limit.millisecondsSinceEpoch - Timestamp.now().millisecondsSinceEpoch;
      if (time > 0) {
        timer.value = time;
      } else {
        _timer.cancel();
      }
    });
  }

  onMoveCamera(MapCameraState onCameraUpdate) {
    SearchOptions searchOptions = SearchOptions.withDefaults();
    searchOptions.languageCode = LanguageCode.esEs;
    searchOptions.maxItems = 5;

    searchEngine.searchByCoordinates(
      onCameraUpdate.targetCoordinates,
      searchOptions,
      (error, list) {
        Place place = list![0];
        if (isFocusOrigin.isTrue) {
          origin.value = DirectionModel(
            title: place.address.addressText.split(',')[0],
            coords: place.geoCoordinates!,
          );
        }
        if (isFocusOrigin.isFalse) {
          destination.value = DirectionModel(
            title: place.address.addressText.split(',')[0],
            coords: place.geoCoordinates!,
          );
        }
      }
    );
  }

  @override
  void onClose() {
    loading.value = true;
    loadingCars.value = true;
    cars.clear();
    trackings.value.clear();
    messages.value.clear();
    trackingsSubscription.pause();
    trackingSubscription.pause();
    messagesSubscription.pause();
    handleBookingSubscription?.cancel();
    handleTrackingsSubscription?.cancel();
    handleTrackingsSubscription = null;
    handleMessagesSubscription?.cancel();
    handleTrackingSubscription?.cancel();
    handlePaymentMethodSubscription?.cancel();
    handleMyPositionSubscription?.cancel();
    if (mapController.value != null) {
      if (afterIndicators.isNotEmpty) {
        for (TrackingModel tracking in afterIndicators) {
          tracking.indicator.disable();
          mapController.value!.removeLifecycleListener(tracking.indicator);
        }
        afterIndicators.clear();
      }

      if (driverIndicator.value != null) {
        driverIndicator.value!.disable();
        mapController.value!.removeLifecycleListener(driverIndicator.value!);
        driverIndicator.value = null;
      }

      mapController.value!.gestures.panListener = null;
    }
    closeNotification.value = false;
    super.onClose();
  }
}