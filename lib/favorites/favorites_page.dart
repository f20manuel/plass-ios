import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plass/favorites/favorites_add_page.dart';
import 'package:plass/favorites/favorites_controller.dart';
import 'package:get/get.dart';
import 'package:plass/models/favorite.dart';

class FavoritesPage extends GetView<FavoritesController> {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios)
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Get.to(() => const FavoritesAddPage()),
            icon: const Icon(Icons.add),
            label: Text('Agregar'.toUpperCase()),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(38.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 16.0, bottom: 16),
            child: Row(
              children: const [
                Text(
                  'Mis favoritos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )
                )
              ],
            )
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    width: 1.0,
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                  ),
                  bottom: BorderSide(
                    width: 1.0,
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                  )
                ),
              ),
              child: controller.app.userInfo.home != null || controller.app.userInfo.job != null ? Column(
                children: [
                  Obx(() => ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
                    ),
                    onPressed: () {
                      Get.back(result: controller.app.userInfo.home);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 0, 0, 0.1),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(right: 8.0),
                              child: const Icon(
                                Icons.home_outlined,
                                color: Colors.black26,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: Text(
                                controller.app.userInfo.home != null
                                ? controller.app.userInfo.home!.title
                                : 'Casa',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600
                                )
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.chevron_right_outlined,
                          size: 28.0,
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                        ),
                      ]
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 64.0,
                          height: 1.0,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 0, 0, 0.1),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                      ]
                    ),
                  ),
                  Obx(() => ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
                    ),
                    onPressed: () {
                      Get.back(result: controller.app.userInfo.job);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 0, 0, 0.1),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(right: 8.0),
                              child: const Icon(
                                Icons.business_center_outlined,
                                color: Colors.black26,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: Text(
                                controller.app.userInfo.job != null
                                ? controller.app.userInfo.job!.title
                                : 'Trabajo',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600
                                )
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.chevron_right_outlined,
                          size: 28.0,
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                        ),
                      ]
                    ),
                  )),
                ],
              ) : Container(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Otros lugares'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )
              )
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    width: 1.0,
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                  ),
                  bottom: BorderSide(
                    width: 1.0,
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                  )
                ),
              ),
              child: GetX<FavoritesController>(
                init: Get.put<FavoritesController>(FavoritesController()),
                builder: (controller) => SizedBox(
                width: Get.width,
                height: Get.height * 0.60,
                child: controller.favoritePlaces.isNotEmpty
                  ? ListView.separated(
                  itemCount: controller.favoritePlaces.length,
                  separatorBuilder: (context, index) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    FavoritePlaceModel data = controller.favoritePlaces[index];
                    return ListTile(
                      onTap: () {
                        Get.back(result: data.address);
                      },
                      leading: const Icon(
                        Icons.location_on_outlined,
                        size: 30,
                      ),
                      title: Text(
                        data.title
                      ),
                      subtitle: Text(
                        data.address.title,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever_outlined),
                        onPressed:() {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('¿Borrar este lugar?'),
                              content: const Text('¿Quieres confirmar esta acción?'),
                              actions: [
                                TextButton(
                                  onPressed: () => controller.delete(data.id!),
                                  child: const Text('Confirmar')
                                ),
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Cancelar')
                                ),
                              ]
                            )
                          );
                        },
                      ),
                    );
                  }
                )
                : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(100)
                      ),
                      child: const Icon(
                        Icons.location_off_rounded,
                        color: Colors.black54  
                      )
                    ),
                    const Text(
                      'No tienes lugares favoritos'
                    )
                  ]
                ),
              ))
            ),
          ]
        )
      )
    );
  }
}