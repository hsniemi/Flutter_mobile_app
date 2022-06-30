import 'package:flutter/material.dart';
import 'package:flutter_app_summer_project/model/pickable.dart';

//Create a provider by using ChangeNotifier class as a mixin.
class PickableListProvider with ChangeNotifier {
  List<Pickable> _pickableList = [];

  //A getter method that returns a copy of _pickableList.
  List<Pickable> get pickableList => [..._pickableList];

  int get length => _pickableList.length;

  //Replace the name of the given item with the given name.
  void changeName(Pickable pickable) {
    pickable.name = pickable.name;
    notifyListeners();
  }

  //Remove the given PickableHistory object from the history of the given Pickable.
  void removePickableHistoryItem(Pickable pickable, PickableHistory history) {
    pickable.history!.remove(history);
    notifyListeners();
  }

  //Replace the PickableHistory object at the given index in the history of
  //the given Pickable with the given PickableHistory object.
  void updateHistoryItem(
      Pickable pickable, PickableHistory historyItem, int index) {
    pickable.history![index] = historyItem;
    notifyListeners();
  }

  //Add the given PickableHistory object to the beginning of
  //the history list of the given Pickable.
  void addHistoryItem(Pickable item, PickableHistory historyItem) {
    item.history?.insert(0, historyItem);
    notifyListeners();
  }

  void setPickableList(List<Pickable> list) {
    _pickableList.addAll(list);
    notifyListeners();
  }

  //Add the given Pickable into _pickableList.
  void addPickableListItem(Pickable item) {
    _pickableList.add(item);
    notifyListeners();
  }

  //Remove the given Pickable from _pickableList.
  void removePickableListItem(Pickable item) {
    _pickableList.remove(item);
    notifyListeners();
  }
}
