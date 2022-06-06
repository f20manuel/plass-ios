import 'package:plass/models/direction.dart';

class SearchModel {
  late bool? isSelectMap;
  late DirectionModel? origin;
  late DirectionModel? destination;
  late bool? focusOrigin;

  SearchModel({
    this.isSelectMap,
    this.origin,
    this.destination,
    this.focusOrigin,
  });
}