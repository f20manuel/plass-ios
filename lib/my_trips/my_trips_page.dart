import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/booking.dart';
import 'package:plass/models/driver.dart';
import 'package:plass/my_trips/my_trips_controller.dart';
import 'package:plass/resume/resume_binding.dart';
import 'package:plass/resume/resume_page.dart';
import 'package:plass/widgets/currency/currency_page.dart';
import 'package:skeletons/skeletons.dart';

class MyTripsPage extends GetView<MyTripsController> {
  const MyTripsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('Mis viajes'),
          bottom: const TabBar(
            tabs: [
              Tab( text: 'En curso'),
              Tab( text: 'Finalizados'),
              Tab( text: 'Cancelados'),
            ],
          ),
        ),
        body: Obx(() => TabBarView(
            children: [
              // En curso
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: Get.height
                ),
                child: controller.currentBookings.value.isEmpty
                ? Container(
                    width: Get.width,
                    margin: const EdgeInsets.only(top: 32),
                    child: Center(
                      child: Column(
                        children: const [
                          Icon(Icons.car_repair_rounded),
                          Text('No tienes ningún viaje en curso.')
                        ]
                      )
                    )
                  )
                : Scrollbar(
                  child: ListView.builder(
                    itemCount: controller.currentBookings.value.length,
                    itemBuilder: (context, index) {
                      BookingModel booking = controller.currentBookings.value[index];
                      return Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('dd/MM/yyyy').format(DateTime.now()) == DateFormat('dd/MM/yyyy').format(booking.createdAt.toDate())
                              ? 'Hoy, ${DateFormat('hh:mm a').format(booking.createdAt.toDate()).toLowerCase()}'
                              : DateFormat('dd/MM/yyyy, hh:mm a').format(booking.createdAt.toDate()).toLowerCase(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            InkWell(
                              onTap: () => Get.back(result: booking),
                              radius: 20,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: Get.width,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: booking.status == BookingStatus.pending
                                                    ? Colors.lightBlue
                                                    : booking.status == BookingStatus.pickup || booking.status == BookingStatus.drop
                                                      ? Palette.secondary
                                                      : Colors.black45,
                                                  ),
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(
                                                        booking.statusString,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        )
                                                    ),
                                                  )
                                              ),
                                              SizedBox(
                                                height: 32,
                                                child: booking.status != BookingStatus.drop
                                                ? ElevatedButton(
                                                  style: ButtonStyle(
                                                    foregroundColor: MaterialStateProperty.all(Colors.white),
                                                    shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(100),
                                                      )
                                                    )
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => CupertinoAlertDialog(
                                                            title: const Text('¿Cancelar viaje?'),
                                                            content: const Text('¿Estas segur@ que quieres cancelar tu viaje?'),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed: () => Get.back(result: true),
                                                                  child: const Text('SI, CANCELAR')
                                                              ),
                                                              TextButton(
                                                                  onPressed: () {
                                                                    Get.back();
                                                                  },
                                                                  child: const Text('¡NO, REGRESAR!')
                                                              ),
                                                            ]
                                                        )
                                                    ).then((result) {
                                                      if (result != null) {
                                                        if (booking.status == BookingStatus.selectCar) {
                                                          Firestore.collection(
                                                              'bookings').doc(
                                                              booking.id!).delete();
                                                          return;
                                                        }

                                                        Firestore.collection(
                                                          'bookings'
                                                        )
                                                        .doc(booking.id!)
                                                        .update(
                                                          {
                                                            'status': 'cancel'
                                                          }
                                                        );
                                                      }
                                                    });
                                                  },
                                                  child: const Text('Cancelar')
                                                )
                                                : Container(),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Divider(color: Colors.transparent),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  margin: const EdgeInsets.only(bottom: 4),
                                                  child: Material(
                                                      elevation: 1,
                                                      color: Palette.primary,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(100),
                                                          side: const BorderSide(
                                                              color: Colors.white,
                                                              width: 4
                                                          )
                                                      )
                                                  ),
                                                ),
                                                Column(
                                                  children: List.generate(3, (index) =>
                                                      Container(
                                                        width: 4,
                                                        height: 4,
                                                        margin: const EdgeInsets.only(bottom: 4),
                                                        child: Material(
                                                          elevation: 1,
                                                          color: Palette.secondary,
                                                          borderRadius: BorderRadius.circular(1),
                                                        ),
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  margin: const EdgeInsets.only(bottom: 4),
                                                  child: Material(
                                                      elevation: 1,
                                                      color: Palette.secondary,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          side: const BorderSide(
                                                              color: Colors.white,
                                                              width: 4
                                                          )
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const VerticalDivider(color: Colors.transparent),
                                            SizedBox(
                                              height: 70,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: Get.width - 112,
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Text(
                                                        booking.pickup.title,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Palette.secondary,
                                                        )
                                                      ),
                                                    )
                                                  ),
                                                  SizedBox(
                                                    width: Get.width - 112,
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Text(
                                                        booking.drop.title,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Palette.secondary,
                                                        )
                                                      ),
                                                    )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]
                                        ),
                                      ]
                                    ),
                                  ),
                                )
                              ),
                          ]
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Finalizados
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: Get.height
                ),
                child: controller.finishedBookings.value.isEmpty
                    ? Container(
                    width: Get.width,
                    margin: const EdgeInsets.only(top: 32),
                    child: Center(
                        child: Column(
                            children: const [
                              Icon(Icons.car_repair_rounded),
                              Text('No tienes ningún viaje finalizado.')
                            ]
                        )
                    )
                )
                : Scrollbar(
                    child: ListView.builder(
                      itemCount: controller.finishedBookings.value.length,
                      itemBuilder: (context, index) {
                        BookingModel booking = controller.finishedBookings.value[index];
                        return Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    DateFormat('dd/MM/yyyy').format(DateTime.now()) == DateFormat('dd/MM/yyyy').format(booking.createdAt.toDate())
                                        ? 'Hoy, ${DateFormat('hh:mm a').format(booking.createdAt.toDate()).toLowerCase()}'
                                        : DateFormat('dd/MM/yyyy, hh:mm a').format(booking.createdAt.toDate()).toLowerCase(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(0, 0, 0, 0.3),
                                      fontWeight: FontWeight.w600,
                                    )
                                ),
                                InkWell(
                                    onTap: () => Get.to(() => const ResumePage(), binding: ResumeBinding(), arguments: booking),
                                    radius: 20,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 24,
                                                          height: 24,
                                                          margin: const EdgeInsets.only(bottom: 4),
                                                          child: Material(
                                                              elevation: 1,
                                                              color: Palette.primary,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(100),
                                                                  side: const BorderSide(
                                                                      color: Colors.white,
                                                                      width: 4
                                                                  )
                                                              )
                                                          ),
                                                        ),
                                                        Column(
                                                          children: List.generate(1, (index) =>
                                                              Container(
                                                                width: 4,
                                                                height: 4,
                                                                margin: const EdgeInsets.only(bottom: 4),
                                                                child: Material(
                                                                  elevation: 1,
                                                                  color: Palette.secondary,
                                                                  borderRadius: BorderRadius.circular(1),
                                                                ),
                                                              )
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 24,
                                                          height: 24,
                                                          margin: const EdgeInsets.only(bottom: 4),
                                                          child: Material(
                                                              elevation: 1,
                                                              color: Palette.secondary,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(4),
                                                                  side: const BorderSide(
                                                                      color: Colors.white,
                                                                      width: 4
                                                                  )
                                                              )
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const VerticalDivider(color: Colors.transparent),
                                                    SizedBox(
                                                      height: 54,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                              width: Get.width - 112,
                                                              child: SingleChildScrollView(
                                                                scrollDirection: Axis.horizontal,
                                                                child: Text(
                                                                    booking.pickup.title,
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Palette.secondary,
                                                                    )
                                                                ),
                                                              )
                                                          ),
                                                          SizedBox(
                                                              width: Get.width - 112,
                                                              child: SingleChildScrollView(
                                                                scrollDirection: Axis.horizontal,
                                                                child: Text(
                                                                    booking.drop.title,
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Palette.secondary,
                                                                    )
                                                                ),
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]
                                              ),
                                              const Divider(),
                                              FutureBuilder<DriverModel?>(
                                                  future: booking.getDriverInfo(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasError) {
                                                      Firestore.generateLog(snapshot.error, "FutureBuilder<DriverModel?> in my_trips_page");
                                                    }

                                                    if (
                                                    snapshot.connectionState == ConnectionState.done &&
                                                        snapshot.data != null
                                                    ) {
                                                      DriverModel driverInfo = snapshot.data!;
                                                      return Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
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
                                                                            width: 72,
                                                                            height: 72,
                                                                            imageUrl: driverInfo.avatar.isNotEmpty
                                                                                ? driverInfo.avatar
                                                                                : PlassConstants.defaultAvatar,
                                                                            placeholder: (context, string) => SkeletonAvatar(
                                                                                style: SkeletonAvatarStyle(
                                                                                    width: 72,
                                                                                    height: 72,
                                                                                    borderRadius: BorderRadius.circular(10)
                                                                                )
                                                                            ),
                                                                            fit: BoxFit.cover,
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
                                                                            size: 24,
                                                                          )
                                                                      ),
                                                                      const Positioned(
                                                                          bottom: 2,
                                                                          right: 2,
                                                                          child: Icon(
                                                                            Icons.verified_rounded,
                                                                            color: Colors.amber,
                                                                            size: 20,
                                                                          )
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const VerticalDivider(color: Colors.transparent, width: 8),
                                                                  Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: Get.width / 2.4,
                                                                          child: Text(
                                                                              '${driverInfo.firstName.split(" ")[0]} ${driverInfo.lastName?.split(" ")[0] ?? ''}',
                                                                              style: const TextStyle(
                                                                                color: Palette.secondary,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 14,
                                                                              )
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                            children: [
                                                                              const Icon(
                                                                                  Icons.star_rate_rounded,
                                                                                  color: Colors.amber,
                                                                                  size: 16
                                                                              ),
                                                                              Text(
                                                                                  driverInfo.rate.toStringAsFixed(1),
                                                                                  style: const TextStyle(
                                                                                    fontSize: 10,
                                                                                  )
                                                                              )
                                                                            ]
                                                                        ),
                                                                        Row(
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.timer,
                                                                                color: Palette.primary,
                                                                                size: 16,
                                                                              ),
                                                                              Text(
                                                                                  booking.estimatedTime,
                                                                                  style: const TextStyle(
                                                                                    fontSize: 10,
                                                                                  )
                                                                              )
                                                                            ]
                                                                        ),
                                                                        Row(
                                                                            children: [
                                                                              const Icon(
                                                                                  Icons.attach_money_rounded,
                                                                                  color: Palette.secondary
                                                                              ),
                                                                              Currency(
                                                                                value: double.parse(booking.tripCost.toString()),
                                                                                style: const TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
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
                                                                  booking.carType != null
                                                                      ? Image(
                                                                      image: AssetImage('assets/icons/${booking.carType}.png'),
                                                                      width: 55,
                                                                      height: 55,
                                                                      fit: BoxFit.contain
                                                                  )
                                                                      : Container(),
                                                                  Text(
                                                                      driverInfo.vehicleBrand,
                                                                      style: const TextStyle(
                                                                        color: Colors.grey,
                                                                        fontSize: 12,
                                                                      )
                                                                  ),
                                                                  Text(
                                                                      driverInfo.vehicleNumber,
                                                                      style: const TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                      )
                                                                  )
                                                                ]
                                                            )
                                                          ]
                                                      );
                                                    }

                                                    if (snapshot.hasError) {
                                                      Firestore.generateLog(
                                                          snapshot.error.toString(),
                                                          'Line 93 in lib/resume/resume_page.dart'
                                                      );
                                                    }

                                                    return Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                              children: [
                                                                SkeletonAvatar(
                                                                    style: SkeletonAvatarStyle(
                                                                        width: 72,
                                                                        height: 72,
                                                                        borderRadius: BorderRadius.circular(10)
                                                                    )
                                                                ),
                                                                const VerticalDivider(color: Colors.transparent, width: 8),
                                                                Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      SkeletonLine(
                                                                          style: SkeletonLineStyle(
                                                                            width: Get.width / 3,
                                                                            height: 16,
                                                                            borderRadius: BorderRadius.circular(4),
                                                                          )
                                                                      ),
                                                                      const Divider(color: Colors.transparent, height: 8),
                                                                      SkeletonLine(
                                                                          style: SkeletonLineStyle(
                                                                            width: Get.width / 3.3,
                                                                            height: 16,
                                                                            borderRadius: BorderRadius.circular(4),
                                                                          )
                                                                      ),
                                                                      const Divider(color: Colors.transparent, height: 8),
                                                                      SkeletonLine(
                                                                          style: SkeletonLineStyle(
                                                                            width: Get.width / 3.3,
                                                                            height: 16,
                                                                            borderRadius: BorderRadius.circular(4),
                                                                          )
                                                                      ),
                                                                    ]
                                                                ),
                                                              ]
                                                          ),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              SkeletonAvatar(
                                                                  style: SkeletonAvatarStyle(
                                                                      width: 55,
                                                                      height: 55,
                                                                      borderRadius: BorderRadius.circular(10)
                                                                  )
                                                              ),
                                                              const Divider(color: Colors.transparent, height: 8),
                                                              SkeletonLine(
                                                                  style: SkeletonLineStyle(
                                                                    width: 55,
                                                                    height: 12,
                                                                    borderRadius: BorderRadius.circular(4),
                                                                  )
                                                              ),
                                                              const Divider(color: Colors.transparent, height: 8),
                                                              SkeletonLine(
                                                                  style: SkeletonLineStyle(
                                                                    width: 55,
                                                                    height: 12,
                                                                    borderRadius: BorderRadius.circular(4),
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                        ]
                                                    );
                                                  }
                                              )
                                            ]
                                        ),
                                      ),
                                    )
                                ),
                              ]
                          ),
                        );
                      },
                    ),
                  ),
              ),
              // Cancelados
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: Get.height
                ),
                child: controller.canceledBookings.value.isEmpty
                    ? Container(
                    width: Get.width,
                    margin: const EdgeInsets.only(top: 32),
                    child: Center(
                        child: Column(
                            children: const [
                              Icon(Icons.car_repair_rounded),
                              Text('No tienes ningún viaje cancelado.')
                            ]
                        )
                    )
                )
                : Scrollbar(
                  child: ListView.builder(
                    itemCount: controller.canceledBookings.value.length,
                    itemBuilder: (context, index) {
                      BookingModel booking = controller.canceledBookings.value[index];
                      return Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  DateFormat('dd/MM/yyyy').format(DateTime.now()) == DateFormat('dd/MM/yyyy').format(booking.createdAt.toDate())
                                      ? 'Hoy, ${DateFormat('h:mm a').format(booking.createdAt.toDate()).toLowerCase()}'
                                      : DateFormat('dd/MM/yyyy, h:mm A').format(booking.createdAt.toDate()).toLowerCase(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(0, 0, 0, 0.3),
                                    fontWeight: FontWeight.w600,
                                  )
                              ),
                              InkWell(
                                  onTap: () {},
                                  radius: 20,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width: 24,
                                                        height: 24,
                                                        margin: const EdgeInsets.only(bottom: 4),
                                                        child: Material(
                                                            elevation: 1,
                                                            color: Palette.primary,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(100),
                                                                side: const BorderSide(
                                                                    color: Colors.white,
                                                                    width: 4
                                                                )
                                                            )
                                                        ),
                                                      ),
                                                      Column(
                                                        children: List.generate(3, (index) =>
                                                            Container(
                                                              width: 4,
                                                              height: 4,
                                                              margin: const EdgeInsets.only(bottom: 4),
                                                              child: Material(
                                                                elevation: 1,
                                                                color: Palette.secondary,
                                                                borderRadius: BorderRadius.circular(1),
                                                              ),
                                                            )
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 24,
                                                        height: 24,
                                                        margin: const EdgeInsets.only(bottom: 4),
                                                        child: Material(
                                                            elevation: 1,
                                                            color: Palette.secondary,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(4),
                                                                side: const BorderSide(
                                                                    color: Colors.white,
                                                                    width: 4
                                                                )
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const VerticalDivider(color: Colors.transparent),
                                                  SizedBox(
                                                    height: 70,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                            width: Get.width - 112,
                                                            child: SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Text(
                                                                  booking.pickup.title,
                                                                  style: const TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    color: Palette.secondary,
                                                                  )
                                                              ),
                                                            )
                                                        ),
                                                        SizedBox(
                                                            width: Get.width - 112,
                                                            child: SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Text(
                                                                  booking.drop.title,
                                                                  style: const TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    color: Palette.secondary,
                                                                  )
                                                              ),
                                                            )
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]
                                            ),
                                          ]
                                      ),
                                    ),
                                  )
                              ),
                            ]
                        ),
                      );
                    },
                  )
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}