import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:here_sdk/mapview.dart';
import 'package:intl/intl.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/resume/resume_controller.dart';
import 'package:plass/widgets/currency/currency_page.dart';
import 'package:skeletons/skeletons.dart';

import '../models/driver.dart';

class ResumePage extends GetView<ResumeController> {
  const ResumePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.isTrue) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.amber,
            )
          )
        );
      }

      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Get.back(result: ''),
            icon: const Icon(Icons.close_rounded)
          ),
          title: const Text('Detalles del viaje')
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                width: Get.width,
                height: 150,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Palette.primary,
                      width: 1
                    )
                  )
                ),
                child: HereMap(
                  onMapCreated: controller.onMapCreated,
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.now()) == DateFormat('dd/MM/yyyy').format(controller.booking.createdAt.toDate())
                              ? 'Hoy, ${DateFormat('h:mm a').format(controller.booking.createdAt.toDate()).toLowerCase()}'
                              : DateFormat('dd/MM/yyyy, h:mm a').format(controller.booking.createdAt.toDate()).toLowerCase(),
                        ),
                        Currency(
                          value: double.parse(controller.booking.tripCost.toString()),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 24
                          )
                        )
                      ],
                    ),
                    const Divider(color: Colors.transparent, height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder<DriverModel?>(
                          future: controller.booking.getDriverInfo(),
                          builder: (context, snapshot) {
                            if (
                              snapshot.connectionState == ConnectionState.done &&
                              snapshot.data != null
                            ) {
                              DriverModel driverInfo = snapshot.data!;
                              return Text(
                                driverInfo.vehicleNumber
                              );
                            }

                            if (snapshot.hasError) {
                              Firestore.generateLog(
                                snapshot.error.toString(),
                                'Line 93 in lib/resume/resume_page.dart'
                              );
                            }

                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber,
                              )
                            );
                          }
                        ),
                        Text(controller.booking.paymentMethodLocale())
                      ],
                    ),
                        const Divider(color: Colors.transparent),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Column(children: [
                                    Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: Palette.primary,
                                          borderRadius: BorderRadius.circular(100.0),
                                        )
                                    ),
                                    Column(
                                        children: List<Widget>.generate(2, (index) {
                                          return Container(
                                              width: 4.0,
                                              height: 4.0,
                                              color: Colors.black,
                                              margin: const EdgeInsets.symmetric(
                                                  vertical: 4.0
                                              )
                                          );
                                        })
                                    ),
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: Palette.secondary,
                                    )
                                  ]),
                                  Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(8.0),
                                          child: Text(
                                              controller.booking.pickup.title.length > 25
                                                  ? '${controller.booking.pickup.title.substring(0, 25)}...'
                                                  : controller.booking.pickup.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(8.0),
                                          child: Text(
                                            controller.booking.drop.title.length > 25
                                            ? '${controller.booking.drop.title.substring(0, 25)}...'
                                            : controller.booking.drop.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            )
                                          ),
                                        ),
                                      ]),
                                ],
                              ),

                            ]),
                        const Divider(),
                        Obx(() => FutureBuilder<DriverModel?>(
                          future: controller.booking.getDriverInfo(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                              DriverModel driverInfo = snapshot.data!;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            imageUrl: driverInfo.avatar.isNotEmpty
                                            ? driverInfo.avatar
                                            : PlassConstants.defaultAvatar,
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const VerticalDivider(color: Colors.transparent),
                                        controller.booking.customerCommented
                                            ? Text(
                                            'Valoraste a ${driverInfo.firstName}'
                                        )
                                            : Text(
                                            'Valora a ${driverInfo.firstName}'
                                        )
                                      ]
                                  ),
                                  controller.booking.customerCommented
                                      ? RatingBarIndicator(
                                    itemSize: 24,
                                    itemCount: 5,
                                    rating: controller.booking.customerRate,
                                    itemBuilder: (context, index) {
                                      return const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      );
                                    },
                                  )
                                      : ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(100)
                                          )),
                                          foregroundColor: MaterialStateProperty.all(Colors.white)
                                      ),
                                      onPressed: () => Get.defaultDialog(
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
                                                      initialRating: controller.rate.value,
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
                                                        controller.rate.value = value;
                                                      }
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
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
                                                        controller: controller.commentController,
                                                        decoration: InputDecoration(
                                                            hintText: '¿Qué te pareció el viaje?',
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(100),
                                                            ),
                                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16)
                                                        )
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    margin: const EdgeInsets.only(top: 16),
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            foregroundColor: MaterialStateProperty.all(Colors.white),
                                                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(100)
                                                            ))
                                                        ),
                                                        onPressed: () {
                                                          controller.createComment();
                                                        },
                                                        child: const Text('Comentar')
                                                    ),
                                                  )
                                                ],
                                              )
                                          )
                                      ),
                                      child: const Text('Valorar')
                                  )
                                ],
                              );
                            }

                            if (snapshot.hasError) {
                              Firestore.generateLog(
                                  snapshot.error.toString(),
                                  'Line 186 in lib/resume/resume_page.dart'
                              );
                            }

                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber,
                              )
                            );
                          }
                        ))
                      ],
                    ),
                  )
                ]
            )
        )
      );
    });
  }
}