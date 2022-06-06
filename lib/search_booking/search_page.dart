import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:here_sdk/search.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/models/direction.dart';
import 'package:plass/models/search.dart';
import 'package:plass/search_booking/search_controller.dart';

class SearchPage extends GetView<SearchController> {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewPadding;
    final insets = MediaQuery.of(context).viewInsets;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            color: Colors.grey.shade200,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Obx(() => Column(
              children: [
                Material(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: padding.top,
                      left: 8,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (insets.bottom > 0) {
                                  Timer(const Duration(milliseconds: 500), () =>
                                    Get.back()
                                  );
                                } else {
                                  Get.back();
                                }
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Palette.secondary,
                              ),
                              iconSize: 32,
                            ),
                            // controller.origin.value != null &&
                            // controller.destination.value != null
                            // ? TextButton(
                            //   onPressed: () {
                            //     FocusScope.of(context).unfocus();
                            //     if (insets.bottom > 0) {
                            //       Timer(const Duration(milliseconds: 500), () =>
                            //         Get.back(result: SearchModel(
                            //           isSelectMap: null,
                            //           origin: controller.origin.value,
                            //           destination: controller.destination.value,
                            //         ))
                            //       );
                            //     } else {
                            //       Get.back(
                            //         result: SearchModel(
                            //           isSelectMap: null,
                            //           origin: controller.origin.value,
                            //           destination: controller.destination.value,
                            //         )
                            //       );
                            //     }
                            //   },
                            //   child: const Text('Listo')
                            // ) : Container(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11.0),
                          child: Column(
                            children: [
                              const Divider(color: Colors.transparent),
                              Row(
                                children: [
                                  Column(
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
                                        children: List.generate(5, (index) =>
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
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: Get.width - 72,
                                        child: Obx(() => Focus(
                                          onFocusChange: (hasFocus) {
                                            controller.isFocusOrigin.value = hasFocus;
                                          },
                                          child: TextFormField(
                                            controller: controller.originController.value,
                                            style: const TextStyle(
                                              color: Palette.secondary,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Ingresa tu origen',
                                              hintStyle: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none
                                              ),
                                              suffixIcon: controller.isFocusOrigin.isTrue
                                                ? IconButton(
                                                    onPressed: () {
                                                      controller.originController.value.clear();
                                                      controller.origin.value = null;
                                                      controller.places.value = [];
                                                    },
                                                    icon: const Icon(
                                                      Icons.close_rounded,
                                                      color: Palette.primary,
                                                    )
                                                  )
                                                : null,
                                            ),
                                            onChanged: controller.getPlaces
                                          ),
                                        )),
                                      ),
                                      const Divider(color: Colors.black, height: 0),
                                      SizedBox(
                                        width: Get.width - 72,
                                        child: Obx(() => Focus(
                                          onFocusChange: (hasFocus) {
                                            controller.isFocusDestination.value = hasFocus;
                                          },
                                          child: TextFormField(
                                            controller: controller.destinationController.value,
                                            style: const TextStyle(
                                              color: Palette.secondary,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Ingresa tu destino',
                                              hintStyle: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide.none
                                              ),
                                              suffixIcon: controller.isFocusDestination.isTrue
                                                ? IconButton(
                                                    onPressed: () {
                                                      controller.destinationController.value.clear();
                                                      controller.destination.value = null;
                                                      controller.places.value = [];
                                                    },
                                                    icon: const Icon(
                                                      Icons.close_rounded,
                                                      color: Palette.primary,
                                                    )
                                                  )
                                                : null,
                                            ),
                                            onChanged: controller.getPlaces
                                          ),
                                        )),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ),
                controller.places.value.isNotEmpty
                ? Column(
              children: [
                const Divider(color: Colors.transparent),
                Material(
                    elevation: 5,
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 0,
                        maxHeight: 300,
                      ),
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Place place = controller.places.value[index];
                            return ListTile(
                              onTap: () {
                                if (controller.isFocusOrigin.isTrue) {
                                  controller.origin.value = DirectionModel(
                                      title: '${place.address.addressText.split(',')[0]} ${place.address.addressText.split(',')[1]}',
                                      coords: place.geoCoordinates!
                                  );
                                  controller.originController.value.text = '${place.address.addressText.split(',')[0]} ${place.address.addressText.split(',')[1]}';
                                  controller.places.value = [];
                                  if (
                                  controller.origin.value != null &&
                                      controller.destination.value != null
                                  ) {
                                    FocusScope.of(context).unfocus();
                                    Timer(const Duration(milliseconds: 500), () {
                                      Get.back();
                                      controller.homeController
                                          .checkAndInitBooking(
                                          controller.origin.value,
                                          controller.destination.value
                                      );
                                    });
                                    return;
                                  }
                                  return;
                                }

                                controller.destination.value = DirectionModel(
                                    title: '${place.address.addressText.split(',')[0]}, ${place.address.addressText.split(',')[1]}',
                                    coords: place.geoCoordinates!
                                );
                                controller.destinationController.value.text = '${place.address.addressText.split(',')[0]}, ${place.address.addressText.split(',')[1]}';
                                controller.places.value = [];
                                if (
                                controller.origin.value != null &&
                                    controller.destination.value != null
                                ) {
                                  FocusScope.of(context).unfocus();
                                  Timer(const Duration(milliseconds: 500), () {
                                    Get.back();
                                    controller.homeController
                                        .checkAndInitBooking(
                                        controller.origin.value,
                                        controller.destination.value
                                    );
                                  });
                                  return;
                                }
                                controller.homeController.checkAndInitBooking(controller.origin.value, controller.destination.value);
                                return;
                              },
                              leading: const Icon(
                                Icons.location_on_outlined,
                                color: Palette.primary,
                                size: 32,
                              ),
                              title: Text(
                                  place.address.addressText.split(',')[0],
                                  style: const TextStyle(
                                    color: Palette.secondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  )
                              ),
                              subtitle: Text(place.address.addressText.split(',')[1]),
                            );
                          },
                          separatorBuilder: (context, index) =>
                          const Divider(color: Colors.transparent),
                          itemCount: controller.places.value.length,
                        ),
                      ),
                    )
                ),
              ],
            )
                : Container(),
                controller.recent.value.isNotEmpty
                ? Column(
                  children: [
                    const Divider(color: Colors.transparent),
                    Material(
                        elevation: 5,
                        child: Container(
                          constraints: const BoxConstraints(
                            minHeight: 0,
                            maxHeight: 300,
                          ),
                          child: Scrollbar(
                            isAlwaysShown: true,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                DirectionModel place = controller.recent.value[index];
                                return ListTile(
                                  onTap: () {
                                    if (controller.isFocusOrigin.isTrue) {
                                      controller.origin.value = place;
                                      controller.originController.value.text = place.title;
                                      if (
                                        controller.origin.value != null &&
                                        controller.destination.value != null
                                      ) {
                                        FocusScope.of(context).unfocus();
                                        Timer(const Duration(milliseconds: 500), () {
                                          Get.back();
                                          controller.homeController
                                          .checkAndInitBooking(
                                            controller.origin.value,
                                            controller.destination.value
                                          );
                                        });
                                        return;
                                      }
                                      return;
                                    }

                                    controller.destination.value = DirectionModel(
                                      title: place.title,
                                      coords: place.coords
                                    );
                                    controller.destinationController.value.text = place.title;
                                    if (
                                      controller.origin.value != null &&
                                      controller.destination.value != null
                                    ) {
                                      FocusScope.of(context).unfocus();
                                      Timer(const Duration(milliseconds: 500), () {
                                        Get.back();
                                        controller.homeController
                                          .checkAndInitBooking(
                                          controller.origin.value,
                                          controller.destination.value
                                        );
                                      });
                                      return;
                                    }
                                    controller.homeController.checkAndInitBooking(controller.origin.value, controller.destination.value);
                                    return;
                                  },
                                  leading: const Icon(
                                    Icons.location_on_outlined,
                                    color: Palette.primary,
                                    size: 32,
                                  ),
                                  title: Text(
                                    place.title,
                                    style: const TextStyle(
                                      color: Palette.secondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    )
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                const Divider(color: Colors.transparent),
                              itemCount: controller.recent.value.length,
                            ),
                          ),
                        )
                      ),
                  ],
                )
                : Container(),
                const Divider(color: Colors.transparent),
                Material(
                  elevation: 5,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          if (insets.bottom > 0) {
                            FocusScope.of(context).unfocus();
                            Timer(const Duration(milliseconds: 500), () =>
                              Get.back(result: SearchModel(
                                isSelectMap: true,
                                focusOrigin: controller.isFocusOrigin.value,
                              ))
                            );
                          } else {
                            Get.back(
                              result: SearchModel(
                                isSelectMap: true,
                                focusOrigin: controller.isFocusOrigin.value,
                              )
                            );
                          }
                        },
                        leading: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.map_outlined),
                        ),
                        title: const Text('Seleccionar en mapa'),
                      ),
                      ListTile(
                        onTap: () => controller.goToFavorites(controller.isFocusDestination.isTrue),
                        leading: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.star_border_outlined),
                        ),
                        title: const Text('Mis favoritos'),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                      )
                    ]
                  )
                )
              ],
            )),
          )
        ],
      )
    );
  }

}