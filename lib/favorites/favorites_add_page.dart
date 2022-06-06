import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/favorites/favorites_controller.dart';

class FavoritesAddPage extends GetView<FavoritesController> {
  const FavoritesAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios)
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(38.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 16.0, bottom: 16),
            child: Row(
              children: const [
                Text(
                  'Agregar nuevo lugar',
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
      body: SizedBox(
        height: Get.height - MediaQuery.of(context).viewPadding.top -
          MediaQuery.of(context).viewInsets.bottom,
        child: SingleChildScrollView(
          child: Obx(() => Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
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
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nombre del lugar',
                          style:TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: controller.nameController.value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              hintText: 'Escribe el nombre del nuevo lugar',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es requerido';
                              }

                              return null;
                            },
                            // onChanged: (value) => setState(() => addressName = value),
                          ),
                        ),
                      ]
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dirección',
                          style:TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: controller.addressController.value,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              hintText: 'Escribe el nombre o dirección del lugar',
                              suffixIcon: IconButton(
                                onPressed: controller.addressController.value.text.isNotEmpty
                                  ? () {
                                      controller.addressController.value.clear();
                                      controller.newPlace.value = null;
                                      controller.places.value = [];
                                    }
                                  : null,
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: controller.addressController.value.text.isNotEmpty
                                    ? Palette.primary
                                    : Colors.white
                                )
                              )
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su correo electrónico';
                              }

                              return null;
                            },
                            onChanged: (value) async {
                              if (value.isEmpty) {
                                controller.places.value = [];
                                return;       
                              }
                              return controller.getPlaces(value);
                            },
                          ),
                        ),
                      ]
                    ),
                  ]
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: controller.places.isNotEmpty
                  ? controller.places.length <= 3
                    ? 66 * double.parse(controller.places.length.toString())
                    : 200
                  : 0,
                margin: EdgeInsets.only(bottom: controller.places.isNotEmpty ? 8 : 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      width: controller.places.isNotEmpty ? 1.0 : 0,
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                    ),
                    bottom: BorderSide(
                      width: controller.places.isNotEmpty ? 1.0 : 0,
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                    )
                  ),
                ),
                child: ListView.separated(
                  itemCount: controller.places.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
                    ),
                    onPressed: () {
                      Timer(const Duration(milliseconds: 500), () {
                        controller.places.value = [];
                      });
                      
                      controller.addressController.value.text = controller.places[index]['title'];
                      controller.newPlace.value = controller.places[index]['direction'];
                      return;
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(right: 8.0),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: Palette.primary,
                          ),
                        ),
                        SizedBox(
                          width: Get.width,
                          child: Text(
                            controller.places[index]['title'],
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600
                            )
                          ),
                        )
                      ]
                    ),
                  ),
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: controller.newPlace.value != null && controller.addressController.value.text.isNotEmpty
                    ? () => controller.add()
                    : null
                  ,
                  child: controller.loadingAdd.isTrue
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Guardar'
                      )
                )
              )      
            ]
          ))
        ),
      )
    );
  }
}