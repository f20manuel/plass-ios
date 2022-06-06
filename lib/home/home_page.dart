import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:here_sdk/mapview.dart';
import 'package:location/location.dart' as l;
import 'package:plass/application/theme.dart';
import 'package:plass/chat/chat_binding.dart';
import 'package:plass/chat/chat_controller.dart';
import 'package:plass/chat/chat_page.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/home/home_controller.dart';
import 'package:plass/models/booking.dart';
import 'package:plass/models/driver.dart';
import 'package:plass/models/user.dart';
import 'package:plass/widgets/currency/currency_page.dart';
import 'package:plass/widgets/drawer/drawer_widget.dart';
import 'package:plass/widgets/plass_swipe_button/plass_swipe_button_widget.dart';
import 'package:skeletons/skeletons.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);

  final screenKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery
        .of(context)
        .viewPadding;

    return Scaffold(
        key: screenKey,
        drawer: PlassDrawer(screenKey: screenKey),
        body: Stack(
            children: [
              HereMap(
                onMapCreated: controller.onMapCreated,
              ),
              Positioned(
                top: Get.height * 0.25,
                left: Get.width * 0.25,
                right: Get.width * 0.25,
                child: Obx(() {
                  if (controller.loading.isTrue) {
                    return Material(
                      elevation: 8,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                              child: Column(
                                children: const [
                                  CircularProgressIndicator(
                                      backgroundColor: Colors.amber
                                  ),
                                  Divider(color: Colors.transparent),
                                  Text('Buscando ubicación...')
                                ],
                              )
                          )
                      ),
                    );
                  }

                  return Container();
                }),
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    systemOverlayStyle: SystemUiOverlayStyle.dark,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  )
              ),
              Positioned(
                  top: padding.top,
                  left: 0,
                  right: 0,
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() =>
                              MaterialButton(
                                  minWidth: 50,
                                  height: 50,
                                  padding: const EdgeInsets.all(0),
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  onPressed: () {
                                    if (controller.booking.value != null) {
                                      controller.searchButtonOpacity.value =
                                      1.0;
                                      controller.selectMapBannerOpacity.value =
                                      0.0;
                                      controller.isSelectMap.value = false;
                                      controller.destination.value = null;
                                      controller.goToHomeState();
                                      return;
                                    }

                                    if (controller.isSelectMap.isTrue) {
                                      controller.searchButtonOpacity.value =
                                      1.0;
                                      controller.selectMapBannerOpacity.value =
                                      0.0;
                                      controller.isSelectMap.value = false;
                                      controller.destination.value = null;
                                      controller.goToSearch();
                                      return;
                                    }

                                    if (screenKey.currentState != null) {
                                      if (controller.app.connectivityResult
                                          .value != ConnectivityResult.none) {
                                        screenKey.currentState!.openDrawer();
                                        return;
                                      }

                                      PlassConstants.notNetworkMessage();
                                    }
                                  },
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: controller.booking.value != null ||
                                          controller.isSelectMap.isTrue
                                          ? const Icon(
                                          Icons.arrow_back_ios_new_rounded)
                                          : const Image(
                                          image: AssetImage(
                                              'assets/icons/sideMenu.png'),
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.contain
                                      )
                                  )
                              )),
                          MaterialButton(
                              minWidth: 50,
                              height: 50,
                              padding: const EdgeInsets.all(0),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              onPressed: () {
                                if (screenKey.currentState != null) {
                                  if (controller.app.connectivityResult.value !=
                                      ConnectivityResult.none) {
                                    screenKey.currentState!.openDrawer();
                                    return;
                                  }

                                  PlassConstants.notNetworkMessage();
                                }
                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Obx(() =>
                                      CachedNetworkImage(
                                        width: 50,
                                        height: 50,
                                        imageUrl: controller.app.userInfo.avatar
                                            .isNotEmpty
                                            ? controller.app.userInfo.avatar
                                            : PlassConstants.defaultAvatar,
                                      ))
                              )
                          )
                        ],
                      )
                  )
              ),
              Positioned(
                top: Get.height / 3,
                right: 16,
                child: FutureBuilder<l.PermissionStatus>(
                    future: controller.hereService.location.hasPermission(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data! == l.PermissionStatus.granted) {
                          return MaterialButton(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              minWidth: 48,
                              height: 48,
                              padding: const EdgeInsets.all(0),
                              onPressed: controller.ccurrentLocation,
                              child: const Icon(Icons.my_location_rounded)
                          );
                        }
                      }

                      return Container();
                    }
                ),
              ),
              // Booking sections
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Stack(
                  children: [
                    Container(
                      height: Get.height,
                    ),
                    // Home Section
                    Positioned(
                      bottom: MediaQuery
                          .of(context)
                          .viewPadding
                          .bottom,
                      left: 0,
                      right: 0,
                      child: Obx(() =>
                          AnimatedOpacity(
                              opacity: controller.booking.value == null &&
                                  controller.isSelectMap.isFalse
                                  ? 1 : 0,
                              duration: const Duration(milliseconds: 300),
                              child: controller.booking.value == null &&
                                  controller.isSelectMap.isFalse
                                  ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        controller.engoingBookings.value
                                            .isNotEmpty
                                            ? MaterialButton(
                                            height: 48,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(100)
                                            ),
                                            color: Palette.secondary,
                                            onPressed: () =>
                                                controller
                                                    .goToCurrentBookings(),
                                            child: Row(
                                              children: const [
                                                Text(
                                                    'Tienes viajes en curso',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    )
                                                ),
                                                VerticalDivider(
                                                    color: Colors.transparent),
                                                Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    color: Colors.white
                                                ),
                                              ],
                                            )
                                        )
                                            : Container()
                                      ],
                                    ),
                                    const Divider(color: Colors.transparent),
                                    Material(
                                        elevation: 1,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Column(
                                            children: [
                                              MaterialButton(
                                                  color: Colors.grey.shade200,
                                                  height: 64,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(20),
                                                      side: const BorderSide(
                                                        color: Colors.white,
                                                        width: 8,
                                                      )
                                                  ),
                                                  onPressed: controller
                                                      .goToSearch,
                                                  child: Row(
                                                      children: [
                                                        Container(
                                                            width: 24,
                                                            height: 24,
                                                            decoration: BoxDecoration(
                                                                color: Palette
                                                                    .primary,
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    100),
                                                                border: Border
                                                                    .all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 4,
                                                                )
                                                            )
                                                        ),
                                                        const VerticalDivider(
                                                            color: Colors
                                                                .transparent),
                                                        SizedBox(
                                                          width: Get.width /
                                                              1.5,
                                                          child: const Text(
                                                            '¿A dónde vamos?',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              color: Palette
                                                                  .secondary,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        )
                                                      ]
                                                  )
                                              ),
                                              controller.app.userInfo.home !=
                                                  null &&
                                                  controller.app.userInfo.job !=
                                                      null
                                                  ? Column(
                                                children: [
                                                  const Divider(
                                                      color: Colors.transparent,
                                                      height: 8
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () {
                                                      controller.destination
                                                          .value =
                                                          controller.app
                                                              .userInfo.home;
                                                      controller
                                                          .checkAndInitBooking(
                                                          controller.origin
                                                              .value,
                                                          controller.destination
                                                              .value
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .all(8.0),
                                                      child: Row(
                                                          children: [
                                                            Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200,
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        100)
                                                                ),
                                                                padding: const EdgeInsets
                                                                    .all(8),
                                                                child: const Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .home_rounded
                                                                    )
                                                                )
                                                            ),
                                                            const VerticalDivider(
                                                                color: Colors
                                                                    .transparent),
                                                            SizedBox(
                                                              width: Get.width -
                                                                  137,
                                                              child: Text(
                                                                  controller.app
                                                                      .userInfo
                                                                      .home!
                                                                      .title
                                                              ),
                                                            )
                                                          ]
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  MaterialButton(
                                                    onPressed: () {
                                                      controller.destination
                                                          .value =
                                                          controller.app
                                                              .userInfo.job;
                                                      controller
                                                          .checkAndInitBooking(
                                                          controller.origin
                                                              .value,
                                                          controller.destination
                                                              .value
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .all(8.0),
                                                      child: Row(
                                                          children: [
                                                            Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200,
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        100)
                                                                ),
                                                                padding: const EdgeInsets
                                                                    .all(8),
                                                                child: const Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .business_rounded
                                                                    )
                                                                )
                                                            ),
                                                            const VerticalDivider(
                                                                color: Colors
                                                                    .transparent),
                                                            SizedBox(
                                                              width: Get.width -
                                                                  137,
                                                              child: Text(
                                                                  controller.app
                                                                      .userInfo
                                                                      .job!
                                                                      .title
                                                              ),
                                                            )
                                                          ]
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(
                                                      color: Colors.transparent,
                                                      height: 8
                                                  ),
                                                ],
                                              )
                                                  : Container(),
                                              controller.app.userInfo.home !=
                                                  null &&
                                                  controller.app.userInfo.job ==
                                                      null
                                                  ? Column(
                                                children: [
                                                  const Divider(
                                                      color: Colors.transparent,
                                                      height: 8
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () {
                                                      controller.destination
                                                          .value =
                                                          controller.app
                                                              .userInfo.home;
                                                      controller
                                                          .checkAndInitBooking(
                                                          controller.origin
                                                              .value,
                                                          controller.destination
                                                              .value
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .all(8.0),
                                                      child: Row(
                                                          children: [
                                                            Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200,
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        100)
                                                                ),
                                                                padding: const EdgeInsets
                                                                    .all(8),
                                                                child: const Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .home_rounded
                                                                    )
                                                                )
                                                            ),
                                                            const VerticalDivider(
                                                                color: Colors
                                                                    .transparent),
                                                            SizedBox(
                                                              width: Get.width -
                                                                  137,
                                                              child: Text(
                                                                  controller.app
                                                                      .userInfo
                                                                      .home!
                                                                      .title
                                                              ),
                                                            )
                                                          ]
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(
                                                      color: Colors.transparent,
                                                      height: 8
                                                  ),
                                                ],
                                              )
                                                  : Container(),
                                              controller.app.userInfo.home ==
                                                  null &&
                                                  controller.app.userInfo.job !=
                                                      null
                                                  ? Column(
                                                children: [
                                                  const Divider(
                                                      color: Colors.transparent,
                                                      height: 8
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () {
                                                      controller.destination
                                                          .value =
                                                          controller.app
                                                              .userInfo.job;
                                                      controller
                                                          .checkAndInitBooking(
                                                          controller.origin
                                                              .value,
                                                          controller.destination
                                                              .value
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .all(8.0),
                                                      child: Row(
                                                          children: [
                                                            Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200,
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        100)
                                                                ),
                                                                padding: const EdgeInsets
                                                                    .all(8),
                                                                child: const Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .business_rounded
                                                                    )
                                                                )
                                                            ),
                                                            const VerticalDivider(
                                                                color: Colors
                                                                    .transparent),
                                                            SizedBox(
                                                              width: Get.width -
                                                                  137,
                                                              child: Text(
                                                                  controller.app
                                                                      .userInfo
                                                                      .job!
                                                                      .title
                                                              ),
                                                            )
                                                          ]
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(
                                                      color: Colors.transparent,
                                                      height: 8
                                                  ),
                                                ],
                                              )
                                                  : Container(),
                                            ]
                                        )
                                    ),
                                  ],
                                ),
                              )
                                  : Container()
                          )),
                    ),
                    // Select Car Section
                    Positioned(
                      left: 8,
                      right: 8,
                      bottom: 0,
                      child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            if (details.localPosition.dy > 64) {
                              controller.closeSweetBottom.value = true;
                              return;
                            }
                            controller.closeSweetBottom.value = false;
                          },
                          child: Obx(() {
                            if (controller.booking.value != null) {
                              return Column(
                                  children: [
                                    Material(
                                        elevation: 4,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                        child: AnimatedContainer(
                                            height: controller.booking.value!
                                                .status ==
                                                BookingStatus.selectCar &&
                                                controller.closeSweetBottom
                                                    .isFalse
                                                ? 460 + padding.bottom : 64,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            decoration: BoxDecoration(
                                                color: controller.booking.value!
                                                    .couldByWoman
                                                    ? Palette.lila
                                                    : Colors.white,
                                                borderRadius: const BorderRadius
                                                    .only(
                                                  topLeft: Radius.circular(
                                                      20.0),
                                                  topRight: Radius.circular(
                                                      20.0),
                                                )
                                            ),
                                            child: AnimatedOpacity(
                                              opacity: controller.booking.value!
                                                  .status ==
                                                  BookingStatus.selectCar
                                                  ? 1
                                                  : 0,
                                              duration: const Duration(
                                                  seconds: 1),
                                              child: controller.booking.value!
                                                  .status ==
                                                  BookingStatus.selectCar
                                                  ? Column(
                                                  children: [
                                                    Column(children: [
                                                      Container(
                                                          width: 60.0,
                                                          height: 4.0,
                                                          margin: const EdgeInsets
                                                              .only(top: 8.0,
                                                              bottom: 32.0),
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey
                                                                .shade300,
                                                            borderRadius: BorderRadius
                                                                .circular(
                                                                100.0),
                                                          )
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(top: 0.0,
                                                            bottom: 32.0),
                                                        child: Row(children: [
                                                          SizedBox(
                                                              width: 40.0,
                                                              child: Column(
                                                                  children: [
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          bottom: 4.0),
                                                                      child: Material(
                                                                        elevation: 1.0,
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            100.0),
                                                                        child: Container(
                                                                            width: 12.0,
                                                                            height: 12.0,
                                                                            margin: const EdgeInsets
                                                                                .all(
                                                                                4.0),
                                                                            decoration: const BoxDecoration(
                                                                                color: Palette
                                                                                    .primary,
                                                                                shape: BoxShape
                                                                                    .circle
                                                                            )
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        width: 4.0,
                                                                        height: 4.0,
                                                                        margin: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical: 4.0),
                                                                        decoration: const BoxDecoration(
                                                                            color: Colors
                                                                                .black87,
                                                                            shape: BoxShape
                                                                                .rectangle
                                                                        )
                                                                    ),
                                                                    Container(
                                                                        width: 4.0,
                                                                        height: 4.0,
                                                                        margin: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical: 4.0),
                                                                        decoration: const BoxDecoration(
                                                                            color: Colors
                                                                                .black87,
                                                                            shape: BoxShape
                                                                                .rectangle
                                                                        )
                                                                    ),
                                                                    Container(
                                                                        width: 4.0,
                                                                        height: 4.0,
                                                                        margin: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical: 4.0),
                                                                        decoration: const BoxDecoration(
                                                                            color: Colors
                                                                                .black87,
                                                                            shape: BoxShape
                                                                                .rectangle
                                                                        )
                                                                    ),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical: 4.0),
                                                                      child: Material(
                                                                        elevation: 1.0,
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            4.0),
                                                                        child: Container(
                                                                            width: 12.0,
                                                                            height: 12.0,
                                                                            margin: const EdgeInsets
                                                                                .all(
                                                                                4.0),
                                                                            decoration: const BoxDecoration(
                                                                                color: Palette
                                                                                    .secondary,
                                                                                shape: BoxShape
                                                                                    .rectangle
                                                                            )
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ]
                                                              )),
                                                          SizedBox(
                                                            width: Get.width -
                                                                86,
                                                            child: Column(
                                                                children: [
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        bottom: 16),
                                                                    decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          100),
                                                                    ),
                                                                    child: MaterialButton(
                                                                      minWidth: Get
                                                                          .width,
                                                                      height: 48,
                                                                      shape: RoundedRectangleBorder(
                                                                        side: const BorderSide(
                                                                          width: 1,
                                                                          color: Colors
                                                                              .grey,
                                                                        ),
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            100),
                                                                      ),
                                                                      onPressed: controller
                                                                          .modifySearch,
                                                                      child: SizedBox(
                                                                        width: Get
                                                                            .width,
                                                                        child: Text(
                                                                          controller
                                                                              .booking
                                                                              .value
                                                                              ?.pickup
                                                                              .title ??
                                                                              '',
                                                                          style: const TextStyle(
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                          ),
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          100),
                                                                    ),
                                                                    child: MaterialButton(
                                                                      minWidth: Get
                                                                          .width,
                                                                      height: 48,
                                                                      shape: RoundedRectangleBorder(
                                                                        side: const BorderSide(
                                                                          width: 1,
                                                                          color: Colors
                                                                              .grey,
                                                                        ),
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            100),
                                                                      ),
                                                                      onPressed: controller
                                                                          .modifySearch,
                                                                      child: SizedBox(
                                                                        width: Get
                                                                            .width,
                                                                        child: Text(
                                                                          controller
                                                                              .booking
                                                                              .value
                                                                              ?.drop
                                                                              .title ??
                                                                              '',
                                                                          style: const TextStyle(
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                          ),
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ]),
                                                          )
                                                        ]),
                                                      ),
                                                      Container(
                                                          width: Get.width,
                                                          margin: const EdgeInsets
                                                              .only(left: 16,
                                                              bottom: 16),
                                                          child: Text(
                                                              'SERVICIOS SUGERIDOS',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                color: controller
                                                                    .booking
                                                                    .value !=
                                                                    null &&
                                                                    controller
                                                                        .booking
                                                                        .value!
                                                                        .couldByWoman
                                                                    ? Colors
                                                                    .white
                                                                    : Colors
                                                                    .black,
                                                              )
                                                          )
                                                      ),
                                                      controller.loadingCars
                                                          .isTrue
                                                          ? const Center(
                                                          child: CircularProgressIndicator(
                                                            backgroundColor: Colors
                                                                .amber,
                                                          )
                                                      )
                                                          : SizedBox(
                                                        width: Get.width - 16,
                                                        height: 120,
                                                        child: ListView
                                                            .separated(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 16),
                                                            scrollDirection: Axis
                                                                .horizontal,
                                                            separatorBuilder: (
                                                                BuildContext context,
                                                                int index) =>
                                                                Container(
                                                                    margin: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 8)
                                                                ),
                                                            itemCount: controller
                                                                .cars.length,
                                                            itemBuilder: (
                                                                BuildContext context,
                                                                int index) {
                                                              return MaterialButton(
                                                                  minWidth: 100,
                                                                  elevation: 0,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          10)
                                                                  ),
                                                                  color: controller
                                                                      .selectedCar['name'] ==
                                                                      controller
                                                                          .cars[index]['name']
                                                                      ? controller
                                                                      .booking
                                                                      .value !=
                                                                      null &&
                                                                      controller
                                                                          .booking
                                                                          .value!
                                                                          .couldByWoman
                                                                      ? Colors
                                                                      .white
                                                                      : Palette
                                                                      .primary
                                                                      : controller
                                                                      .booking
                                                                      .value !=
                                                                      null &&
                                                                      controller
                                                                          .booking
                                                                          .value!
                                                                          .couldByWoman
                                                                      ? Colors
                                                                      .white24
                                                                      : const Color
                                                                      .fromRGBO(
                                                                      0, 0, 0,
                                                                      0.1),
                                                                  onPressed: () =>
                                                                  controller
                                                                      .selectedCar
                                                                      .value =
                                                                  controller
                                                                      .cars[index],
                                                                  child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Container(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child: Center(
                                                                            child: Image(
                                                                                image: AssetImage(
                                                                                    'assets/icons/${controller
                                                                                        .cars[index]['name']}.png'),
                                                                                width: 50,
                                                                                fit: BoxFit
                                                                                    .contain
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                            controller
                                                                                .cars[index]['name']
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight
                                                                                    .bold,
                                                                                color: controller
                                                                                    .booking
                                                                                    .value !=
                                                                                    null &&
                                                                                    controller
                                                                                        .booking
                                                                                        .value!
                                                                                        .couldByWoman
                                                                                    ? controller
                                                                                    .selectedCar['name'] ==
                                                                                    controller
                                                                                        .cars[index]['name']
                                                                                    ? Colors
                                                                                    .black
                                                                                    : Colors
                                                                                    .white
                                                                                    : Colors
                                                                                    .black
                                                                            )
                                                                        ),
                                                                        controller
                                                                            .cars[index]['name'] ==
                                                                            'taxi'
                                                                            ? Text(
                                                                            'Taximetro',
                                                                            style: TextStyle(
                                                                              color: controller
                                                                                  .selectedCar['name'] ==
                                                                                  controller
                                                                                      .cars[index]['name']
                                                                                  ? controller
                                                                                  .booking
                                                                                  .value !=
                                                                                  null &&
                                                                                  controller
                                                                                      .booking
                                                                                      .value!
                                                                                      .couldByWoman
                                                                                  ? Palette
                                                                                  .lila
                                                                                  : Colors
                                                                                  .white
                                                                                  : controller
                                                                                  .booking
                                                                                  .value !=
                                                                                  null &&
                                                                                  controller
                                                                                      .booking
                                                                                      .value!
                                                                                      .couldByWoman
                                                                                  ? Colors
                                                                                  .white60
                                                                                  : Colors
                                                                                  .grey,
                                                                              fontSize: 14,
                                                                            )
                                                                        )
                                                                            : Center(
                                                                          child: Currency(
                                                                              value: double
                                                                                  .parse(
                                                                                  controller
                                                                                      .cars[index]['price']
                                                                                      .toString()),
                                                                              style: TextStyle(
                                                                                color: controller
                                                                                    .selectedCar['name'] ==
                                                                                    controller
                                                                                        .cars[index]['name']
                                                                                    ? controller
                                                                                    .booking
                                                                                    .value !=
                                                                                    null &&
                                                                                    controller
                                                                                        .booking
                                                                                        .value!
                                                                                        .couldByWoman
                                                                                    ? Palette
                                                                                    .lila
                                                                                    : Colors
                                                                                    .white
                                                                                    : controller
                                                                                    .booking
                                                                                    .value !=
                                                                                    null &&
                                                                                    controller
                                                                                        .booking
                                                                                        .value!
                                                                                        .couldByWoman
                                                                                    ? Colors
                                                                                    .white60
                                                                                    : Colors
                                                                                    .grey,
                                                                                fontSize: 14,
                                                                              )
                                                                          ),
                                                                        ),
                                                                      ]
                                                                  )
                                                              );
                                                            }
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 24,
                                                        margin: const EdgeInsets
                                                            .all(16),
                                                        child: Row(
                                                            children: [
                                                              MaterialButton(
                                                                  onPressed: () =>
                                                                      controller
                                                                          .openPaymentMethod(),
                                                                  child: SizedBox(
                                                                    child: Row(
                                                                        children: [
                                                                          Text(
                                                                              controller
                                                                                  .payment
                                                                                  .value
                                                                                  ?.name ??
                                                                                  ''),
                                                                          const Icon(
                                                                              Icons
                                                                                  .chevron_right_rounded)
                                                                        ]
                                                                    ),
                                                                  )
                                                              )
                                                            ]
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: Get.width - 64,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            controller.app
                                                                .userInfo
                                                                .gender ==
                                                                Gender.male &&
                                                                controller
                                                                    .booking
                                                                    .value !=
                                                                    null
                                                                ? Container()
                                                                : Switch(
                                                              inactiveThumbColor: Palette
                                                                  .lila,
                                                              inactiveThumbImage: const AssetImage(
                                                                  'assets/icons/by-woman.png'),
                                                              inactiveTrackColor: Colors
                                                                  .black12,
                                                              value: controller
                                                                  .booking
                                                                  .value!
                                                                  .couldByWoman,
                                                              activeColor: Colors
                                                                  .white,
                                                              onChanged: (
                                                                  bool value) {
                                                                controller
                                                                    .bookingsService
                                                                    .setCouldByWoman(
                                                                    controller
                                                                        .booking
                                                                        .value!,
                                                                    value
                                                                );
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: controller.booking.value!.couldByWoman ? null : Get.width - 64,
                                                              height: 46,
                                                              child: ElevatedButton(
                                                                  style: ButtonStyle(
                                                                    backgroundColor: MaterialStateProperty
                                                                        .all(
                                                                        controller
                                                                            .booking
                                                                            .value !=
                                                                            null &&
                                                                            controller
                                                                                .booking
                                                                                .value!
                                                                                .couldByWoman
                                                                            ? Palette
                                                                            .lila
                                                                            : Palette
                                                                            .primary
                                                                    ),
                                                                    foregroundColor: MaterialStateProperty
                                                                        .all(
                                                                        Colors
                                                                            .white),
                                                                    shape: MaterialStateProperty
                                                                        .all(
                                                                        RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              10),
                                                                        )),
                                                                  ),
                                                                  onPressed: controller
                                                                      .selectedCar
                                                                      .isNotEmpty
                                                                      ? () =>
                                                                      controller
                                                                          .requestBooking()
                                                                      : () {
                                                                    showDialog(
                                                                        context: context,
                                                                        builder: (
                                                                            context) =>
                                                                            CupertinoAlertDialog(
                                                                                title: const Text(
                                                                                    '¡Espera!'),
                                                                                content: const Text(
                                                                                    'Debes seleccionar una tarifa.'),
                                                                                actions: [
                                                                                  TextButton(
                                                                                      onPressed: () =>
                                                                                          Get
                                                                                              .back(),
                                                                                      child: const Text(
                                                                                          'OK')
                                                                                  )
                                                                                ]
                                                                            )
                                                                    );
                                                                  },
                                                                  child: const Text(
                                                                      'SOLICITAR AHORA')
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ]),
                                                  ]
                                              )
                                                  : Container(),
                                            )
                                        )
                                    )
                                  ]
                              );
                            }

                            return Container();
                          })
                      ),
                    ),
                    // Pending Section
                    Positioned(
                      left: 8,
                      right: 8,
                      bottom: 0,
                      child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            if (details.localPosition.dy > 64) {
                              controller.pendingHeight.value = 64;
                              return;
                            }
                            controller.pendingHeight.value =
                                controller.persistencePendingHeight.value;
                          },
                          child: Obx(() {
                            if (controller.booking.value != null) {
                              return Column(
                                  children: [
                                    Material(
                                        elevation: 4,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                        child: AnimatedContainer(
                                            height: controller.booking.value!
                                                .status == BookingStatus.pending
                                                ? controller.pendingHeight.value
                                                .toDouble()
                                                : 0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            decoration: BoxDecoration(
                                                color: controller.booking.value!
                                                    .couldByWoman
                                                    ? Palette.lila
                                                    : Colors.white,
                                                borderRadius: const BorderRadius
                                                    .only(
                                                  topLeft: Radius.circular(
                                                      20.0),
                                                  topRight: Radius.circular(
                                                      20.0),
                                                )
                                            ),
                                            child: AnimatedOpacity(
                                                opacity: controller.booking
                                                    .value!.status ==
                                                    BookingStatus.pending
                                                    ? 1
                                                    : 0,
                                                duration: const Duration(
                                                    seconds: 1),
                                                child: Center(
                                                    child: controller.booking
                                                        .value!.status !=
                                                        BookingStatus.pending
                                                        ? Container()
                                                        : Column(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Container(
                                                              width: 59,
                                                              height: 8,
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  top: 16),
                                                              decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    100),
                                                              )
                                                          ),
                                                          controller.timer
                                                              .value > 1000
                                                              ? Column(
                                                            children: [
                                                              Stack(
                                                                children: const [
                                                                  Center(
                                                                    child: SizedBox(
                                                                      width: 50,
                                                                      height: 50,
                                                                      child: CircularProgressIndicator(
                                                                        backgroundColor: Colors
                                                                            .amber,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  /*Center(
                                                            child: SizedBox(
                                                              width: 50,
                                                              height: 50,
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 8,
                                                                value: double.parse((controller.timer.value / 300000).toStringAsFixed(2)),
                                                                backgroundColor: Colors.grey.shade100,
                                                                valueColor: const AlwaysStoppedAnimation(Palette.primary),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                              top: 0,
                                                              left: 0,
                                                              right: 0,
                                                              bottom: 0,
                                                              child: Center(
                                                                  child: Text(
                                                                      "${Duration(milliseconds: controller.timer.value.toInt()).inMinutes}:${(Duration(milliseconds: controller.timer.value).inSeconds%60).toString().padLeft(2, '0')}",
                                                                      style: const TextStyle(
                                                                          color: Palette.secondary,
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 24
                                                                      )
                                                                  )
                                                              )
                                                          )*/
                                                                ],
                                                              ),
                                                              const Divider(
                                                                  color: Colors
                                                                      .transparent),
                                                              const Center(
                                                                  child: Text(
                                                                      'Estamos procesando tu servicio.',
                                                                      style: TextStyle(
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                      )
                                                                  )
                                                              ),
                                                              const Center(
                                                                  child: Text(
                                                                    'Tu viaje empezará pronto... ',
                                                                  )
                                                              ),
                                                            ],
                                                          )
                                                              : controller
                                                              .loadingPanel
                                                              .isTrue
                                                              ? const Center(
                                                              child: CircularProgressIndicator(
                                                                  color: Colors
                                                                      .amber
                                                              )
                                                          )
                                                              : Column(
                                                              children: [
                                                                SizedBox(
                                                                  width: Get
                                                                      .width -
                                                                      48,
                                                                  child: const Text(
                                                                    'No hemos podido conseguir un conductor para ti.',
                                                                    style: TextStyle(
                                                                      color: Palette
                                                                          .secondary,
                                                                      fontSize: 24,
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                    ),
                                                                    textAlign: TextAlign
                                                                        .center,
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                    color: Colors
                                                                        .transparent),
                                                                SizedBox(
                                                                  width: Get
                                                                      .width -
                                                                      48,
                                                                  height: 59,
                                                                  child: ElevatedButton(
                                                                    style: ButtonStyle(
                                                                        foregroundColor: MaterialStateProperty
                                                                            .all(
                                                                            Colors
                                                                                .white),
                                                                        shape: MaterialStateProperty
                                                                            .all(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  100),
                                                                            ))
                                                                    ),
                                                                    onPressed: () =>
                                                                        controller
                                                                            .initTimer(
                                                                            controller
                                                                                .booking
                                                                                .value!),
                                                                    child: const Text(
                                                                        'Continuar'),
                                                                  ),
                                                                )
                                                              ]
                                                          ),
                                                          Container(
                                                            margin: const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 16.0),
                                                            child: PlassSwipeButton(
                                                                activeText: 'Cancelando...',
                                                                inactiveText: 'Desliza para cancelar',
                                                                onChanged: () async {
                                                                  await Firestore
                                                                      .collection(
                                                                      'bookings')
                                                                      .doc(
                                                                      controller
                                                                          .booking
                                                                          .value!
                                                                          .id!)
                                                                      .update({
                                                                    'status': 'cancel'
                                                                  });

                                                                  Get.back();
                                                                }
                                                            ),
                                                          ),
                                                          const Divider(
                                                              color: Colors
                                                                  .transparent)
                                                        ]
                                                    )
                                                )
                                            )
                                        )
                                    )
                                  ]
                              );
                            }

                            return Container();
                          })
                      ),
                    ),
                    // Pickup Section
                    Positioned(
                        bottom: 0,
                        left: 8,
                        right: 8,
                        child: Obx(() =>
                            GestureDetector(
                                onPanEnd: (details) {
                                  if (details.velocity.pixelsPerSecond
                                      .direction > 0) {
                                    controller.pickupHeight.value = 64;
                                    // controller.pickupHeightChange.value = true;
                                    return;
                                  } else {
                                    controller.pickupHeight.value = controller
                                        .persistencePickupHeight.value;
                                    return;
                                  }
                                },
                                child: AnimatedContainer(
                                    height: controller.booking.value != null &&
                                        controller.booking.value!.status ==
                                            BookingStatus.waiting
                                        ? 16 + controller.pickupHeight.value
                                        .toDouble() + padding.bottom :
                                    controller.booking.value != null &&
                                        controller.booking.value!.status ==
                                            BookingStatus.pickup ||
                                        controller.booking.value != null &&
                                            controller.booking.value!.status ==
                                                BookingStatus.drop
                                        ? controller.pickupHeight.value
                                        .toDouble() + padding.bottom
                                        : 0,
                                    duration: const Duration(milliseconds: 500),
                                    child: controller.booking.value != null
                                        ? Material(
                                        color: Colors.white,
                                        elevation: 5,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                              children: [
                                                Container(
                                                    width: 75,
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .shade400,
                                                      borderRadius: BorderRadius
                                                          .circular(100),
                                                    )
                                                ),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Obx(() =>
                                                          SizedBox(
                                                            width: Get.width *
                                                                0.5,
                                                            child: Text(
                                                                controller
                                                                    .booking
                                                                    .value
                                                                    ?.status ==
                                                                    BookingStatus
                                                                        .waiting
                                                                    ? 'Tu afiliado te esta esperando, llega a tiempo: ${Duration(
                                                                    milliseconds: controller
                                                                        .timer
                                                                        .value
                                                                        .toInt())
                                                                    .inMinutes} m ${(Duration(
                                                                    milliseconds: controller
                                                                        .timer
                                                                        .value)
                                                                    .inSeconds %
                                                                    60)
                                                                    .toString()
                                                                    .padLeft(
                                                                    2, '0')} s.'
                                                                    : controller
                                                                    .booking
                                                                    .value
                                                                    ?.status ==
                                                                    BookingStatus
                                                                        .pickup
                                                                    ? 'Tu afiliado llega en ${controller
                                                                    .estimateTime
                                                                    .value
                                                                    .toInt() <
                                                                    60 &&
                                                                    controller
                                                                        .estimateTime
                                                                        .value
                                                                        .toInt() >
                                                                        0
                                                                    ? 1
                                                                    : Duration(
                                                                    seconds: controller
                                                                        .estimateTime
                                                                        .value
                                                                        .toInt())
                                                                    .inMinutes} m.'
                                                                    : controller
                                                                    .booking
                                                                    .value
                                                                    ?.status ==
                                                                    BookingStatus
                                                                        .drop
                                                                    ? 'Disfruta tu viaje'
                                                                    : '',
                                                                style: const TextStyle(
                                                                  color: Palette
                                                                      .secondary,
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                )
                                                            ),
                                                          )),
                                                      Obx(() {
                                                        if (
                                                        controller.booking.value
                                                            ?.status ==
                                                            BookingStatus
                                                                .waiting ||
                                                            controller.booking
                                                                .value
                                                                ?.status ==
                                                                BookingStatus
                                                                    .pickup
                                                        ) {
                                                          return TextButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (
                                                                        context) =>
                                                                        CupertinoAlertDialog(
                                                                            title: const Text(
                                                                                '¿Cancelar viaje?'),
                                                                            content: const Text(
                                                                                '¿Estas segur@ que quieres cancelar tu viaje?'),
                                                                            actions: [
                                                                              TextButton(
                                                                                  onPressed: () =>
                                                                                      Get
                                                                                          .back(
                                                                                          result: true),
                                                                                  child: const Text(
                                                                                      'SI, CANCELAR')
                                                                              ),
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    Get
                                                                                        .back();
                                                                                  },
                                                                                  child: const Text(
                                                                                      '¡NO, REGRESAR!')
                                                                              ),
                                                                            ]))
                                                                    .then((
                                                                    result) {
                                                                  if (result !=
                                                                      null) {
                                                                    Firestore
                                                                        .collection(
                                                                        'bookings')
                                                                        .doc(
                                                                        controller
                                                                            .booking
                                                                            .value!
                                                                            .id)
                                                                        .update(
                                                                        {
                                                                          'status': 'cancel'
                                                                        });
                                                                  }
                                                                });
                                                              },
                                                              child: const Text(
                                                                  'Cancelar viaje'
                                                              )
                                                          );
                                                        }

                                                        return Container();
                                                      })
                                                    ]
                                                ),
                                                const Divider(
                                                    color: Colors.grey),
                                                Obx(() {
                                                  if (controller.booking
                                                      .value != null) {
                                                    return FutureBuilder<
                                                        DriverModel?>(
                                                        future: controller
                                                            .booking.value!
                                                            .getDriverInfo(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (
                                                          snapshot
                                                              .connectionState ==
                                                              ConnectionState
                                                                  .done &&
                                                              snapshot.data !=
                                                                  null
                                                          ) {
                                                            DriverModel driverInfo = snapshot
                                                                .data!;
                                                            return Column(
                                                              children: [
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                          children: [
                                                                            Stack(
                                                                              children: [
                                                                                Material(
                                                                                  shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                          100),
                                                                                      side: const BorderSide(
                                                                                        color: Palette
                                                                                            .primary,
                                                                                        width: 4,
                                                                                      )
                                                                                  ),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                        100),
                                                                                    child: CachedNetworkImage(
                                                                                      width: 72,
                                                                                      height: 72,
                                                                                      imageUrl: driverInfo
                                                                                          .avatar
                                                                                          .isNotEmpty
                                                                                          ? driverInfo
                                                                                          .avatar
                                                                                          : PlassConstants
                                                                                          .defaultAvatar,
                                                                                      placeholder: (
                                                                                          context,
                                                                                          string) =>
                                                                                          SkeletonAvatar(
                                                                                              style: SkeletonAvatarStyle(
                                                                                                  width: 72,
                                                                                                  height: 72,
                                                                                                  borderRadius: BorderRadius
                                                                                                      .circular(
                                                                                                      10)
                                                                                              )
                                                                                          ),
                                                                                      fit: BoxFit
                                                                                          .cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Positioned(
                                                                                  bottom: 2,
                                                                                  right: 2,
                                                                                  child: Container(
                                                                                      width: 18,
                                                                                      height: 18,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius
                                                                                            .circular(
                                                                                            100),
                                                                                        color: Colors
                                                                                            .white,
                                                                                      )
                                                                                  )
                                                                                ),
                                                                                const Positioned(
                                                                                    bottom: 0,
                                                                                    right: 0,
                                                                                    child: Icon(
                                                                                      Icons
                                                                                          .verified_rounded,
                                                                                      color: Colors
                                                                                          .white,
                                                                                      size: 24,
                                                                                    )
                                                                                ),
                                                                                const Positioned(
                                                                                    bottom: 2,
                                                                                    right: 2,
                                                                                    child: Icon(
                                                                                      Icons
                                                                                          .verified_rounded,
                                                                                      color: Colors
                                                                                          .amber,
                                                                                      size: 20,
                                                                                    )
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const VerticalDivider(
                                                                                color: Colors
                                                                                    .transparent,
                                                                                width: 8),
                                                                            Column(
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: Get
                                                                                        .width /
                                                                                        2.4,
                                                                                    child: Text(
                                                                                        '${driverInfo
                                                                                            .firstName
                                                                                            .split(
                                                                                            " ")[0]} ${driverInfo
                                                                                            .lastName
                                                                                            ?.split(
                                                                                            " ")[0] ??
                                                                                            ''}',
                                                                                        style: const TextStyle(
                                                                                          color: Palette
                                                                                              .secondary,
                                                                                          fontWeight: FontWeight
                                                                                              .bold,
                                                                                          fontSize: 14,
                                                                                        )
                                                                                    ),
                                                                                  ),
                                                                                  Row(
                                                                                      children: [
                                                                                        const Icon(
                                                                                            Icons
                                                                                                .star_rate_rounded,
                                                                                            color: Colors
                                                                                                .amber,
                                                                                            size: 16
                                                                                        ),
                                                                                        Text(
                                                                                            driverInfo
                                                                                                .rate
                                                                                                .toStringAsFixed(
                                                                                                1),
                                                                                            style: const TextStyle(
                                                                                              fontSize: 10,
                                                                                            )
                                                                                        )
                                                                                      ]
                                                                                  ),
                                                                                  Row(
                                                                                      children: [
                                                                                        const Icon(
                                                                                          Icons
                                                                                              .timer,
                                                                                          color: Palette
                                                                                              .primary,
                                                                                          size: 16,
                                                                                        ),
                                                                                        Text(
                                                                                            controller
                                                                                                .booking
                                                                                                .value!
                                                                                                .estimatedTime,
                                                                                            style: const TextStyle(
                                                                                              fontSize: 10,
                                                                                            )
                                                                                        )
                                                                                      ]
                                                                                  ),
                                                                                  Row(
                                                                                      children: [
                                                                                        const Icon(
                                                                                            Icons
                                                                                                .attach_money_rounded,
                                                                                            color: Palette
                                                                                                .secondary
                                                                                        ),
                                                                                        Currency(
                                                                                          value: double
                                                                                              .parse(
                                                                                              controller
                                                                                                  .booking
                                                                                                  .value!
                                                                                                  .tripCost
                                                                                                  .toString()),
                                                                                          style: const TextStyle(
                                                                                            fontWeight: FontWeight
                                                                                                .bold,
                                                                                            color: Colors
                                                                                                .black,
                                                                                          ),
                                                                                        )
                                                                                      ]
                                                                                  )
                                                                                ]
                                                                            ),
                                                                          ]
                                                                      ),
                                                                      Column(
                                                                          children: [
                                                                            controller
                                                                                .booking
                                                                                .value!
                                                                                .carType !=
                                                                                null
                                                                                ? Image(
                                                                                image: AssetImage(
                                                                                    'assets/icons/${controller
                                                                                        .booking
                                                                                        .value!
                                                                                        .carType}.png'),
                                                                                width: 55,
                                                                                height: 55,
                                                                                fit: BoxFit
                                                                                    .contain
                                                                            )
                                                                                : Container(),
                                                                            Text(
                                                                                driverInfo
                                                                                    .vehicleBrand,
                                                                                style: const TextStyle(
                                                                                  color: Colors
                                                                                      .grey,
                                                                                  fontSize: 12,
                                                                                )
                                                                            ),
                                                                            Text(
                                                                                driverInfo
                                                                                    .vehicleNumber,
                                                                                style: const TextStyle(
                                                                                  fontWeight: FontWeight
                                                                                      .bold,
                                                                                )
                                                                            )
                                                                          ]
                                                                      )
                                                                    ]
                                                                ),
                                                                const Divider(
                                                                    color: Colors
                                                                        .transparent),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal: 16.0),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Obx(() {
                                                                        return Badge(
                                                                          elevation: controller
                                                                              .haveChats
                                                                              .isTrue
                                                                              ? 2
                                                                              : 0,
                                                                          badgeColor: controller
                                                                              .haveChats
                                                                              .isTrue
                                                                              ? Colors
                                                                              .red
                                                                              : Colors
                                                                              .transparent,
                                                                          position: const BadgePosition(
                                                                            top: 2,
                                                                            end: 2,
                                                                          ),
                                                                          child: Material(
                                                                            elevation: 2,
                                                                            color: Palette
                                                                                .primary,
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                100),
                                                                            child: SizedBox(
                                                                              width: 45,
                                                                              height: 45,
                                                                              child: IconButton(
                                                                                  onPressed: () {
                                                                                    if (controller
                                                                                        .booking
                                                                                        .value !=
                                                                                        null) {
                                                                                      Get
                                                                                          .to(() =>
                                                                                      const ChatPage(),
                                                                                          binding: ChatBinding(),
                                                                                          arguments: ChatArguments(
                                                                                              booking: controller
                                                                                                  .booking
                                                                                                  .value!
                                                                                          )
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                  color: Colors
                                                                                      .white,
                                                                                  icon: const Icon(
                                                                                      Icons
                                                                                          .message_rounded)
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                                      SizedBox(
                                                                        width: 120,
                                                                        height: 45,
                                                                        child: FutureBuilder<
                                                                            DriverModel?>(
                                                                            future: controller
                                                                                .booking
                                                                                .value!
                                                                                .getDriverInfo(),
                                                                            builder: (
                                                                                context,
                                                                                snapshot) {
                                                                              if (
                                                                              snapshot
                                                                                  .connectionState ==
                                                                                  ConnectionState
                                                                                      .done &&
                                                                                  snapshot
                                                                                      .data !=
                                                                                      null
                                                                              ) {
                                                                                DriverModel driverInfo = snapshot
                                                                                    .data!;
                                                                                return ElevatedButton(
                                                                                    style: ButtonStyle(
                                                                                        backgroundColor: MaterialStateProperty
                                                                                            .all(
                                                                                            Colors
                                                                                                .white
                                                                                        ),
                                                                                        foregroundColor: MaterialStateProperty
                                                                                            .all(
                                                                                            Palette
                                                                                                .primary
                                                                                        ),
                                                                                        shape: MaterialStateProperty
                                                                                            .all(
                                                                                            RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius
                                                                                                    .circular(
                                                                                                    10),
                                                                                                side: const BorderSide(
                                                                                                  width: 1,
                                                                                                  color: Palette
                                                                                                      .primary,
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                    ),
                                                                                    onPressed: () =>
                                                                                        launch(
                                                                                            'tel:${driverInfo
                                                                                                .mobile
                                                                                                .isNotEmpty
                                                                                                ? driverInfo
                                                                                                .mobile
                                                                                                : '3000000000'}'
                                                                                        ),
                                                                                    child: const Text(
                                                                                        'Llamar')
                                                                                );
                                                                              }

                                                                              if (snapshot
                                                                                  .hasError) {
                                                                                Firestore
                                                                                    .generateLog(
                                                                                    snapshot
                                                                                        .error
                                                                                        .toString(),
                                                                                    'Line 1254 in lib/home/home_page.dart'
                                                                                );
                                                                              }

                                                                              return const Center(
                                                                                  child: CircularProgressIndicator(
                                                                                      color: Colors
                                                                                          .amber
                                                                                  )
                                                                              );
                                                                            }
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        style: ButtonStyle(
                                                                            shape: MaterialStateProperty
                                                                                .all<
                                                                                RoundedRectangleBorder>(
                                                                                RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                        18.0),
                                                                                    side: const BorderSide(
                                                                                        color: Colors
                                                                                            .red)
                                                                                )
                                                                            )
                                                                        ),
                                                                        onPressed: () =>
                                                                            launch(
                                                                                'tel:123'
                                                                            ),
                                                                        child: const Text(
                                                                          "S.O.S.",
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .red
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }

                                                          if (snapshot
                                                              .hasError) {
                                                            Firestore
                                                                .generateLog(
                                                                snapshot.error
                                                                    .toString(),
                                                                'Line 93 in lib/resume/resume_page.dart'
                                                            );
                                                          }

                                                          return Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Row(
                                                                    children: [
                                                                      SkeletonAvatar(
                                                                          style: SkeletonAvatarStyle(
                                                                              width: 72,
                                                                              height: 72,
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  10)
                                                                          )
                                                                      ),
                                                                      const VerticalDivider(
                                                                          color: Colors
                                                                              .transparent,
                                                                          width: 8),
                                                                      Column(
                                                                          crossAxisAlignment: CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            SkeletonLine(
                                                                                style: SkeletonLineStyle(
                                                                                  width: Get
                                                                                      .width /
                                                                                      3,
                                                                                  height: 16,
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      4),
                                                                                )
                                                                            ),
                                                                            const Divider(
                                                                                color: Colors
                                                                                    .transparent,
                                                                                height: 8),
                                                                            SkeletonLine(
                                                                                style: SkeletonLineStyle(
                                                                                  width: Get
                                                                                      .width /
                                                                                      3.3,
                                                                                  height: 16,
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      4),
                                                                                )
                                                                            ),
                                                                            const Divider(
                                                                                color: Colors
                                                                                    .transparent,
                                                                                height: 8),
                                                                            SkeletonLine(
                                                                                style: SkeletonLineStyle(
                                                                                  width: Get
                                                                                      .width /
                                                                                      3.3,
                                                                                  height: 16,
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      4),
                                                                                )
                                                                            ),
                                                                          ]
                                                                      ),
                                                                    ]
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    SkeletonAvatar(
                                                                        style: SkeletonAvatarStyle(
                                                                            width: 55,
                                                                            height: 55,
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                10)
                                                                        )
                                                                    ),
                                                                    const Divider(
                                                                        color: Colors
                                                                            .transparent,
                                                                        height: 8),
                                                                    SkeletonLine(
                                                                        style: SkeletonLineStyle(
                                                                          width: 55,
                                                                          height: 12,
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              4),
                                                                        )
                                                                    ),
                                                                    const Divider(
                                                                        color: Colors
                                                                            .transparent,
                                                                        height: 8),
                                                                    SkeletonLine(
                                                                        style: SkeletonLineStyle(
                                                                          width: 55,
                                                                          height: 12,
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              4),
                                                                        )
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]
                                                          );
                                                        }
                                                    );
                                                  }
                                                  return Container();
                                                }),
                                              ]
                                          ),
                                        )
                                    )
                                        : Container()
                                )
                            ))
                    )
                  ],
                ),
              ),
              Positioned(
                  top: Get.height * 0.37,
                  left: Get.height * 0.025,
                  right: Get.height * 0.025,
                  child: Obx(() =>
                      Column(
                        children: [
                          AnimatedOpacity(
                            opacity: controller.selectMapBannerOpacity.value,
                            duration: const Duration(milliseconds: 500),
                            child: controller.selectMapBannerOpacity.value > 0
                                ? MaterialButton(
                              color: Colors.white,
                              padding: const EdgeInsets.all(0),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                controller.checkAndInitBooking(
                                    controller.origin.value,
                                    controller.destination.value
                                );
                              },
                              child: SizedBox(
                                  width: 250,
                                  height: 59,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Container(
                                            width: 59,
                                            height: 59,
                                            decoration: const BoxDecoration(
                                                color: Palette.secondary,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                      10.0),
                                                  bottomLeft: Radius.circular(
                                                      10.0),
                                                )
                                            ),
                                            padding: const EdgeInsets.all(12.0),
                                            child: const Image(
                                                image: AssetImage(
                                                    'assets/icons/HandUp.png'
                                                )
                                            )
                                        ),
                                        Container(
                                          width: 141,
                                          height: 59,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                bottomRight: Radius.circular(
                                                    10.0),
                                              )
                                          ),
                                          padding: const EdgeInsets.all(4.0),
                                          child: Center(
                                            child: Text(
                                                controller.destination.value
                                                    ?.title ?? 'Mueve el mapa'),
                                          ),
                                        ),
                                        const Icon(
                                            Icons.chevron_right_outlined,
                                            color: Colors.grey
                                        )
                                      ]
                                  )
                              ),
                            )
                                : Container(),
                          ),
                          AnimatedOpacity(
                              opacity: controller.selectMapBannerOpacity.value,
                              duration: const Duration(milliseconds: 300),
                              child: controller.selectMapBannerOpacity.value > 0
                                  ? Container(
                                  width: 4,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Palette.secondary,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(100.0),
                                        bottomRight: Radius.circular(100.0)
                                    ),
                                  )
                              )
                                  : Container()
                          )
                        ],
                      ))
              )
            ]
        )
    );
  }
}