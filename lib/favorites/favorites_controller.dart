import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/search.dart';
import 'package:plass/application/controller.dart';
import 'package:plass/constants.dart';
import 'package:plass/firestore.dart';
import 'package:plass/models/direction.dart';
import 'package:plass/models/favorite.dart';
import 'package:plass/services/favorites_service.dart';

class FavoritesController extends GetxController {
  var favoritesPlacesList = Rx<List<FavoritePlaceModel>>([]);
  List<FavoritePlaceModel> get favoritePlaces => favoritesPlacesList.value;
  var places = [].obs;
  var newPlace = Rx<DirectionModel?>(null);
  var loadingAdd = false.obs;
  late StreamSubscription favoritePlacesListener;

  final AppController app = Get.find();
  final auth = FirebaseAuth.instance;
  final FavoritesService favoritesService = Get.find();
  final nameController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final _searchEngine = SearchEngine();

  @override
  void onReady() {
    favoritesPlacesList.bindStream(favoritesService.streamByUser(auth.currentUser));
  }

  void delete(String id) async {
    try {
      await Firestore.collection('favorite_places').doc(id).delete();

      Get.back();
    } on FirebaseException catch(e) {
      Get.snackbar('Error', e.toString());
    }
  }


  void add() {
    loadingAdd.value = true;

    Firestore.collection('favorite_places').add({
      'title': addressController.value.text,
      'address': {
        'title': newPlace.value!.title,
        'latitude': newPlace.value!.coords.latitude,
        'longitude': newPlace.value!.coords.longitude,
      },
      'user_uid': app.userInfo.id,
    })
    .then((doc) {
      nameController.value.clear();
      addressController.value.clear();
      newPlace.value = null;
      loadingAdd.value = false;
      Get.back();
    })
    .catchError((e) => throw Exception(e));
  }

  void getPlaces(String address) {
  SearchOptions searchOptions = SearchOptions.withDefaults();
  searchOptions.languageCode = LanguageCode.esEs;
  searchOptions.maxItems = 5;
  List items = [];

  // Simulate a user typing a search term.
  _searchEngine.suggest(
    TextQuery.withCircleArea(
      address, // User typed "p".
      PlassConstants.bogotaCircleArea,
    ),
    searchOptions, (SearchError? searchError, List<Suggestion>? list) {
      for (Suggestion item in list!) {
        String title = item.title.split(',')[0];
        if (title.isNotEmpty) {
          items.add({
            'title': title,
            'direction': DirectionModel(
              title: title,
              coords: GeoCoordinates(
                item.place!.geoCoordinates!.latitude,
                item.place!.geoCoordinates!.longitude
              )
            )
          });
        }
      }
      
      places.value = items;
    });
  }
}