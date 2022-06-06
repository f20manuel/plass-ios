import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/chat/chat_controller.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/driver.dart';
import 'package:plass/models/message.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            if (MediaQuery.of(context).viewInsets.bottom > 0) {
              FocusScope.of(context).unfocus();
              Timer(const Duration(milliseconds: 500), () {
                Get.back();
              });
              return;
            }

            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded)
        ),
        title: controller.args != null
          ? FutureBuilder<DriverModel?>(
            future: controller.args!.booking.getDriverInfo(),
            builder: (context, snapshot) {
              if (
                snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null
              ) {
                DriverModel driverInfo = snapshot.data!;
                return Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          imageUrl: driverInfo.avatar.isNotEmpty
                          ? driverInfo.avatar
                          : PlassConstants.defaultAvatar,
                          placeholder: (context, title) => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.amber
                            )
                          ),
                        )
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${driverInfo.firstName} ${driverInfo.lastName ?? ''}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              )
                            ),
                            Text(
                              driverInfo.vehicleNumber.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              )
                            ),
                          ]
                      ),
                    )
                  ],
                );
              }

              if (snapshot.hasError) {
                Firestore.generateLog(
                  snapshot.error.toString(),
                  'lib/chat/chat_page.dart'
                );
              }

              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber
                )
              );
          }
        )
        : Container()
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: Get.width,
              height: Get.height - 156 -
                MediaQuery.of(context).viewInsets.bottom - MediaQuery.of(context).viewPadding.bottom,
              child: Obx(() => controller.loading.isFalse ? ListView.separated(
                controller: controller.scrollController.value,
                padding: const EdgeInsets.all(16),
                itemCount: controller.chat.value?.messages.length ?? 0,
                separatorBuilder: (context, index) => Container(
                  height: 8
                ),
                itemBuilder: (context, index) {
                  MessageModel? data = controller.chat.value?.messages[index];

                  if (
                    index == 0 &&
                    data?.from == 'user'
                  ) {
                    return Bubble(
                      alignment: Alignment.topRight,
                      nip: BubbleNip.rightTop,
                      child: Stack(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(data?.message ?? '')
                          ),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: data?.status == "pending"
                                  ? const Icon(
                                  Icons.done_rounded,
                                  size: 12,
                                  color: Colors.black38
                              )
                                  : const Icon(
                                  Icons.done_all_rounded,
                                  size: 12,
                                  color: Palette.primary
                              )
                          )
                        ],
                      ),
                    );
                  } else if (
                    index == 0 &&
                    data?.from == 'driver'
                  ) {
                    return Bubble(
                      alignment: Alignment.topLeft,
                      nip: BubbleNip.leftTop,
                      color: Palette.primary,
                      child: Text(
                        data?.message ?? '',
                        style: const TextStyle(
                          color: Colors.white
                        )
                      )
                    );
                  } else if (
                    index > 0 &&
                    controller.chat.value?.messages[index -1].from == 'user' &&
                    data?.from == 'user'
                  ) {
                    return Bubble(
                      alignment: Alignment.topRight,
                      margin: const BubbleEdges.only(right: 8),
                      child: Stack(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(data?.message ?? '')
                          ),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: data?.status == "pending"
                                  ? const Icon(
                                  Icons.done_rounded,
                                  size: 12,
                                  color: Colors.black38
                              )
                                  : const Icon(
                                  Icons.done_all_rounded,
                                  size: 12,
                                  color: Palette.primary
                              )
                          )
                        ],
                      ),
                    );
                  } else if (
                    index > 0 &&
                    controller.chat.value?.messages[index -1].from == 'driver' &&
                    data?.from == 'user'
                  ) {
                    return Bubble(
                      alignment: Alignment.topRight,
                      nip: BubbleNip.rightTop,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(data?.message ?? '')
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: data?.status == "pending"
                            ? const Icon(
                                Icons.done_rounded,
                                size: 12,
                                color: Colors.black38
                              )
                            : const Icon(
                                Icons.done_all_rounded,
                                size: 12,
                                color: Palette.primary
                            )
                          )
                        ],
                      ),
                    );
                  } else if (
                    index > 0 &&
                    controller.chat.value?.messages[index -1].from == 'driver' &&
                    data?.from == 'driver'
                  ) {
                    return Bubble(
                      color: Palette.primary,
                      alignment: Alignment.topLeft,
                      margin: const BubbleEdges.only(left: 6),
                      child: Text(
                        data?.message ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                        )
                      ),
                    );
                  } else if (
                    index > 0 &&
                    controller.chat.value?.messages[index -1].from == 'user' &&
                    data?.from == 'driver'
                  ) {
                    return Bubble(
                      color: Palette.primary,
                      alignment: Alignment.topLeft,
                      nip: BubbleNip.leftTop,
                      child: Text(
                        data?.message ?? '',
                        style: const TextStyle(
                          color: Colors.white
                        ),
                      ),
                    );
                  }

                  return Container();
                }
              ) : Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(backgroundColor: Colors.amber),
                    Text('Cargando mensajes...')
                  ],
                ),
              ))
            ),
            Material(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.only(
                  top: 8,
                  left: 8,
                  right: 8,
                  bottom: MediaQuery.of(context).viewPadding.bottom + 8,
                ),
                decoration: const BoxDecoration(
                  color: Palette.primary
                ),
                  child: Obx(() => TextField(
                    controller: controller.newMessageController.value,
                    keyboardType: TextInputType.multiline,
                    maxLines: controller.newMessage.value.length > Get.width * 0.09
                    ? 2
                    : 1,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Mensaje',
                      hintMaxLines: 1,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none
                      ),
                      suffixIcon: IconButton(
                        icon: controller.loadingSend.isTrue
                          ? const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.amber,
                              )
                            )
                          : const Icon(Icons.send_rounded),
                        onPressed: controller.newMessage.value.isNotEmpty &&
                          controller.loadingSend.isFalse
                          ? controller.send : null,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18)
                    ),
                    onChanged: (value) => controller.newMessage.value = value,
                  ))
              ),
            )
          ]
        ),
      )
    );
  }
}