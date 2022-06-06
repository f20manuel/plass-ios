import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/search.dart';
import 'package:plass/constants.dart';
import 'package:plass/favorites/favorites_binding.dart';
import 'package:plass/favorites/favorites_page.dart';
import 'package:plass/firestore.dart';
import 'package:plass/home/home_controller.dart';
import 'package:plass/models/direction.dart';
import 'package:plass/services/users_service.dart';

class SearchArguments {
  late DirectionModel? origin;
  late DirectionModel? destination;

  SearchArguments({
    this.origin,
    this.destination,
  });
}

class SearchController extends GetxController {
  SearchArguments args = Get.arguments;

  var recent = Rx<List<DirectionModel>>([]);
  var origin = Rx<DirectionModel?>(null);
  var destination = Rx<DirectionModel?>(null);
  var isFocusOrigin = false.obs;
  var isFocusDestination = false.obs;
  var places = Rx<List<Place>>([]);

  // Services
  final UsersService usersService = Get.find();

  final HomeController homeController = Get.find();

  final searchEngine = SearchEngine();
  final originController = TextEditingController().obs;
  final destinationController = TextEditingController().obs;

  @override
  void onReady() {
    getRecent();
    super.onReady();
    if (args.origin != null) {
      originController.value.text = args.origin!.title;
      origin.value = args.origin;
    }
    if (args.destination != null) {
      destinationController.value.text = args.destination!.title;
      destination.value = args.destination;
      isFocusOrigin.value = false;
      isFocusDestination.value = true;
    }
  }

  Future<void> getRecent() async {
    try {
      recent.value = await usersService.getRecent();
    } on SocketException catch (_) {
      PlassConstants.notNetworkMessage();
    } catch (exception) {
      Firestore.generateLog(exception, "function getRecent => lib/search_booking/search_controller.dart");
    }
  }

  void getPlaces(String address) {
    if (address.isEmpty) {
      places.value = [];
      return;
    }
    SearchOptions searchOptions = SearchOptions.withDefaults();
    searchOptions.languageCode = LanguageCode.esEs;
    List<Place> items = [];

    // Simulate a user typing a search term.
    searchEngine.suggest(
      // TextQuery.withCircleArea(
      //   address, // User typed "p".
      //   PlassConstants.bogotaCircleArea,
      // ),
      TextQuery.withAreaCenterInCountries(
        address,
        origin.value != null
        ? origin.value!.coords
        : PlassConstants.bogotaCoords,
        const [CountryCode.col]
      ),
      searchOptions, (SearchError? searchError, List<Suggestion>? list) {
        for (Suggestion item in list!) {
          items.add(item.place!);
        }

        places.value = items;
      }
    );
  }

  goToFavorites(bool isFocusDestination) async {
    try {
      var result = await Get.to(() => const FavoritesPage(), binding: FavoritesBinding());
      FocusManager.instance.primaryFocus?.unfocus();
      if (result != null) {
        if (isFocusDestination) {
          destinationController.value.text = result.title;
          destination.value = result;

          if (
            origin.value != null &&
            destination.value != null
          ) {
            Get.back();
            homeController.checkAndInitBooking(
              origin.value,
              destination.value
            );
          }
          return;
        }

        originController.value.text = result.title;
        origin.value = result;
        return;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}