import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/search.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/direction.dart';
import 'package:plass/services/users_service.dart';

class NewPlaceArguments {
  late bool isHome;

  NewPlaceArguments({
    required this.isHome,
  });
}

class NewPlaceController extends GetxController {
  NewPlaceArguments args = Get.arguments;

  var places = <Place>[].obs;
  var newPlace = Rx<DirectionModel?>(null);
  var loadingAdd = false.obs;

  final AppController app = Get.find();
  final searchEngine = SearchEngine();

  //services
  final UsersService usersService = Get.find();

  // Fields
  final addressController = TextEditingController().obs;
  var address = ''.obs;

  @override
  void onReady() {
    super.onReady();
    addressController.value.text = args.isHome
      ? app.userInfo.home?.title ?? ''
      : app.userInfo.job?.title ?? '';
    address.value = args.isHome
      ? app.userInfo.home?.title ?? ''
      : app.userInfo.job?.title ?? '';
  }

  add() async {
    try {
      loadingAdd.value = true;

      if (args.isHome) {
        usersService.updateAuth({
          'home': newPlace.toJson(),
        });
        Get.back();
        return;
      }

      usersService.updateAuth({
        'job': newPlace.toJson(),
      });
      Get.back();
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
    } on FirebaseException catch (exception) {
      Firestore.generateLog(exception, 'Line 38 in lib/settings/new_place/new_place_controller.dart');
    }
  }



  getPlaces(String _address) {
    address.value = _address;
    if (_address.isEmpty) {
      places.value = [];
      return;
    }

    SearchOptions searchOptions = SearchOptions.withDefaults();
    searchOptions.languageCode = LanguageCode.esEs;
    searchOptions.maxItems = 5;
    List<Place> items = [];

    // Simulate a user typing a search term.
    searchEngine.suggest(
      TextQuery.withCircleArea(
        _address, // User typed "p".
        PlassConstants.bogotaCircleArea,
      ),
      searchOptions, (SearchError? searchError, List<Suggestion>? list) {
        for (Suggestion item in list!) {
          items.add(item.place!);
        }

        places.value = items;
      }
    );
  }
}