import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/constants.dart';
import 'package:plass/edit_profile/edit_profile_binding.dart';
import 'package:plass/edit_profile/edit_profile_page.dart';
import 'package:plass/widgets/drawer/drawer_controller.dart';
import 'package:skeletons/skeletons.dart';

class PlassDrawer extends GetWidget<PlassDrawerController> {
  const PlassDrawer({Key? key, this.screenKey}) : super(key: key);

  final GlobalKey<ScaffoldState>? screenKey;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: Get.width,
                height: Get.width / 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Color.fromRGBO(65, 213, 251, 0.7),
                      Color.fromRGBO(65, 213, 251, 0.2),
                    ],
                  )
                )
              ),
              Positioned(
                top: 0,
                child: Container(
                  width: Get.width,
                  height: Get.width / 2,
                  padding: const EdgeInsets.only(
                    top: 32.0,
                    left: 16.0,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.only(right: 16.0),
                        child: Obx(() => CircleAvatar(
                          foregroundImage: NetworkImage(
                            controller.auth.userInfo.avatar.isNotEmpty
                            ? controller.auth.userInfo.avatar
                            : PlassConstants.defaultAvatar
                          ),
                        )),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                            '${controller.auth.userInfo.firstName.split(" ")[0]} ${controller.auth.userInfo.lastName?.split(" ")[0] ?? ''}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                            )
                          )),
                          InkWell(
                            onTap: () => Get.to(() => const EditProfilePage(), binding: EditProfileBinding()),
                            // onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: const [
                                  Text(
                                    'Editar perfil',
                                    style: TextStyle(
                                      color: Palette.secondary,
                                    )
                                  ),
                                  Icon(Icons.chevron_right_outlined)
                                ],
                              )
                            ),
                          )
                        ],
                      )
                    ]
                  )
                )
              ),
            ]
          ),
          Container(
            width: Get.width,
            height: 0.5,
            color: Colors.grey,
          ),
          Container(
            width: Get.width,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0
            ),
            child: SizedBox(
              height: Get.height * 0.33,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: PlassConstants.drawerMenu.length,
                itemBuilder: (BuildContext context, int index) {
                  return TextButton.icon(
                    onPressed: () {
                      PlassConstants.drawerMenu[index]['onPressed']();
                      Timer(const Duration(milliseconds: 500), () {
                        screenKey?.currentState?.openEndDrawer();
                      });
                    },
                    icon: PlassConstants.drawerMenu[index]['icon'],
                    label: SizedBox(
                      width: Get.width,
                      child: Text(
                        PlassConstants.drawerMenu[index]['label'],
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )
                      )
                    )
                  );
                },
              ),
            )
          ),
          Container(
            width: Get.width,
            height: 0.5,
            color: Colors.grey,
          ),
          Container(
            width: Get.width,
            margin: const EdgeInsets.only(
              top: 16.0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Row(
              children: const [
                Image(
                  image: AssetImage('assets/main/PlassLogo.png'),
                  width: 120,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Container(
            width: Get.width,
            padding: const EdgeInsets.only(
              left: 34,
            ),
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SkeletonLine(
                    style: SkeletonLineStyle(
                      width: 64,
                      height: 16,
                    )
                  );
                }

                return Text(
                    'v${snapshot.data!.version}',
                    style: const TextStyle(
                        color: Colors.black54
                    )
                );
              }
            ),
          ),
          const Divider(color: Colors.transparent),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text('Estas a punto de cerrar sesión'),
                        actions: [
                          TextButton(
                              child: const Text('ACEPTAR'),
                              onPressed: controller.authService.logout
                          ),
                          TextButton(
                            child: const Text('CANCELAR'),
                            onPressed: () => Get.back(),
                          )
                        ]
                      )
                    ),
                    child: const Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                      )
                    )
                ),
              ],
            ),
          )
        ]
      )
    );
  }

}