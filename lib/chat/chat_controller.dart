import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/home/home_controller.dart';
import 'package:plass/models/booking.dart';
import 'package:plass/models/chat.dart';
import 'package:plass/models/driver.dart';
import 'package:plass/models/message.dart';
import 'package:plass/services/chat_service.dart';
import 'package:plass/services/drivers_service.dart';
import 'package:plass/services/notifications_service.dart';

class ChatArguments {
  final BookingModel booking;

  ChatArguments({
    required this.booking,
  });
}

class ChatController extends GetxController {
  ChatArguments? args = Get.arguments;
  var chat = Rx<ChatModel?>(null);
  var loading = true.obs;
  var loadingSend = false.obs;
  var newMessage = ''.obs;

  // streams
  late StreamSubscription chatSubscription;
  StreamSubscription? handleChatSubscription;

  //services
  final NotificationsService notificationsService = Get.find();
  final DriverService driverService = Get.find();

  //Controllers
  final AppController app = Get.find();
  final HomeController homeController = Get.find();

  final newMessageController = TextEditingController().obs;
  final scrollController = ScrollController().obs;

  @override onInit() {
    chatSubscription = chat.stream.listen(handleChanges);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    if (args != null) {
      handleChatSubscription = Firestore
      .collection('chats')
      .doc('${args?.booking.driver!.id}-${args?.booking.customer.id}-${args?.booking.id}')
      .snapshots()
      .listen((document) {
        ChatModel model = ChatModel.fromDocumentSnapshot(document);
        chat.value = model;
        scrollDown();
      });
      Timer(const Duration(seconds: 2), () {
        loading.value = false;
        update();
      });
    }
  }

  handleChanges(ChatModel? chatModel) async {
    if (app.connectivityResult.value != ConnectivityResult.none) {
      var last = chatModel?.messages.last;
      if (last?.from == 'driver' && last?.status != 'read') {
        await chatModel?.readAllMessages();
      }
    } else {
      PlassConstants.notNetworkMessage();
    }
  }

  scrollDown() {
    if (scrollController.value.hasClients) {
      scrollController.value.animateTo(
        scrollController.value.position.maxScrollExtent + 32,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  send() {
    if (app.connectivityResult.value != ConnectivityResult.none) {
      loadingSend.value = true;
      newMessageController.value.clear();
      chat.value?.messages.add(
          MessageModel.fromMap({
            'from': 'user',
            'message': newMessage.value,
            'status': 'pending',
            'date': Timestamp
                .now()
                .millisecondsSinceEpoch,
          })
      );

      List<MessageModel>? messages = chat.value?.messages;
      List actualMessages = [];

      if (messages != null) {
        for (MessageModel message in messages) {
          Map mapMessage = message.toJson();
          actualMessages.add(mapMessage);
        }
      }

      if (args != null) {
        Firestore
            .collection('chats')
            .doc(
            '${args?.booking.driver?.id}-${args?.booking.customer.id}-${args
                ?.booking.id!}')
            .get()
        .then((document) {
          if (document.exists) {
            document.reference.update({
              'messages': actualMessages,
            });
          } else {
            document.reference.set({
              'created_at': Timestamp.now(),
              'messages': actualMessages,
              'participants': {
                'driver': args?.booking.driver?.id,
                'user': args?.booking.customer.id
              }
            });
          }
          if (args!.booking.driver != null) {
            driverService.getModel(args!.booking.driver!.id)
            .then((driverModel) {
              if (driverModel != null) {
                notificationsService.sendPushNotifications(
                    "${app.userInfo.firstName} ${app.userInfo.lastName ??
                        ''} ha enviado un mensaje",
                    newMessage.value,
                    driverModel.token
                );
              }
            });
          }
          newMessage.value = '';
          loadingSend.value = false;
        });
      }
      loadingSend.value = false;
      return;
    }
    if (!Get.isSnackbarOpen) {
      PlassConstants.notNetworkMessage();
    }
  }

  @override
  void onClose() {
    loading.value = true;
    newMessage.value = '';
    newMessageController.value.clear();
    chatSubscription.cancel();
    handleChatSubscription?.cancel();
    super.onClose();
  }
}