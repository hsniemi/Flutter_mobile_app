import 'package:flutter/foundation.dart';
import 'package:flutter_app_summer_project/db/pickable_database.dart';
import '../model/location.dart';

/*
This class is a provider using ChangeNotifier mixin and containing methods for
manipulating _placeList and notifying listeners about the changes.
*/

class MyLocations with ChangeNotifier {
  List<Place> _placeList = [];

  List<Place> get placeList {
    return [..._placeList]; // Return a copy of _placeList.
  }

  void addPlace(Place place) {
    _placeList.add(place);
    notifyListeners();
  }

  void setPlaceList(List<Place> list) {
    _placeList = list;
  }

  void deletePlace(Place place) {
    _placeList.remove(place);
    notifyListeners();
  }

//Get all the places in place table and store to _placeList.
  Future<void> getAndSetPlaces() async {
    _placeList = PickableDatabase.instance.readPlace() as List<Place>;
    notifyListeners();
  }
}
