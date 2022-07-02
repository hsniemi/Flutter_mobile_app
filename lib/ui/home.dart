// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_app_summer_project/model/location.dart';
import 'package:flutter_app_summer_project/model/pickable.dart';
import 'package:flutter_app_summer_project/providers/my_locations.dart';
import 'package:flutter_app_summer_project/ui/places_list_view.dart';
import 'package:flutter_app_summer_project/ui/weather.dart';

import '../db/pickable_database.dart';
import 'Pickable_list_view_details.dart';
import 'change_name.dart';
import 'create_pickable_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_summer_project/providers/pickable_list_provider.dart';

import 'map_view.dart';

/*
This class creates a scrollable list of cards of Pickable items 
the user has created.
*/

class PickableListView extends StatefulWidget {
  const PickableListView({Key? key}) : super(key: key);

  @override
  State<PickableListView> createState() => _PickableListViewState();
}

class _PickableListViewState extends State<PickableListView> {
  @override
  void initState() {
    super.initState();
    getPickableList();
  }

  @override
  void dispose() {
    PickableDatabase.instance.close();

    super.dispose();
  }

//Get list of Pickables from device memory.
  Future<void> getPickableList() async {
    try {
      List<Pickable> list = await PickableDatabase.instance.readPickables();

      //For each Pickable get a list of history events with matching pickable_ids from db.
      for (var item in list) {
        item.history = await PickableDatabase.instance.readHistories(item.id!);
      }
      List<Place> placeList = await PickableDatabase.instance.readPlace();

      //Take list to provider.
      initializeList(list);
      getAndSetPlaces(placeList);
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Pickable> pickableItemsList =
        Provider.of<PickableListProvider>(context).pickableList;

    debugPrint('Provider.of test $pickableItemsList');
    final theme = Theme.of(context);
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Theme.of(context).primaryColor,
        width: 200,
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                'Paikkatiedot',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            ListTile(
                title: const Text('Sijainti'),
                onTap: () {
                  Navigator.of(context).push<Place>(
                    MaterialPageRoute(
                      builder: (context) => MapView(onSavePlace: _savePlace),
                    ),
                  );
                }),
            ListTile(
              title: const Text('Omat keräilypaikat'),
              onTap: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) => PlacesListView(
                    deletePlace: _deletePlace,
                    savePlace: _savePlace,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Säätiedot'),
              onTap: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) => Weather(),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Sulje',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Omat keräilykohteet",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatePickableView(
                    context: context,
                    createPickable: _createPickable,
                    addToHistory: _addToHistory,
                  ),
                ),
              ),
              icon: Icon(Icons.add_circle_rounded),
            ),
          ),
        ],
      ),
      //Using Consumer class to listen for changes in the pickable list
      //provided by PickableListProvider class.
      body: Consumer<PickableListProvider>(
        builder: ((context, value, ch) => value.pickableList.isEmpty
            ? Center(
                child: Text('Ei Keräilykohteita'),
              )
            : ListView.builder(
                //Build a list view if there are Pickable items in the list.
                itemCount: value.pickableList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(children: [
                    Positioned(
                      child: pickableCard(value.pickableList[index], context),
                    ),
                    Positioned(
                      left: 10.0,
                      top: 10.0,
                      child: IconButton(
                        color: Colors.orangeAccent.shade700,
                        icon: const Icon(Icons.delete_forever_rounded),
                        onPressed: () async {
                          //Show a dialog to confirm that the user want's to
                          //delete the item.
                          bool? result = await showDialog<bool>(
                            context: context,
                            builder: (context) => showAlertDialog(
                                context, value.pickableList[index], theme),
                          );
                          //If result from the dialog is true delete item and all
                          //items in it's history list, then update provider list.
                          if (result == true) {
                            await PickableDatabase.instance.deleteAllHistories(
                                value.pickableList[index].id!);
                            await PickableDatabase.instance
                                .deletePickable(value.pickableList[index].id!);
                            _deleteItem(value.pickableList[index]);
                          }
                        },
                      ),
                    ),
                    Positioned(
                      right: 16.0,
                      top: 12.0,
                      child: IconButton(
                        onPressed: () =>
                            editName(context, value.pickableList, index),
                        icon: Icon(Icons.edit),
                        color: Colors.purpleAccent,
                      ),
                    ),
                  ]);
                })),
      ),
    );
  }

//Create card to show information of the Pickable item.
  Widget pickableCard(Pickable item, BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      height: 180.0,
      child: Card(
        child: InkWell(
          splashColor: theme.colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      style: theme.textTheme.headline1,
                    ),
                  ],
                ),
                Divider(
                  thickness: 4.0,
                  color: Colors.amber[200],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Kerätty:",
                          style: theme.textTheme.bodyText1,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 18.0, bottom: 4.0),
                          child: Text(
                            "${item.totalAmount}",
                            style: theme.textTheme.headline1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: item.totalAmount == 1
                              ? Text(
                                  item.unit,
                                  style: theme.textTheme.bodyText1,
                                )
                              : Text(
                                  "${item.unit}a",
                                  style: theme.textTheme.bodyText1,
                                ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          onTap: () => Navigator.push(
            context,
            //instance of MaterialPageRoute with a builder function
            //creates what we want to appear on the screen
            MaterialPageRoute(
              builder: (context) => PickableListViewDetails(
                pickable: item,
                addToHistory: _addToHistory,
                updateHistory: _updateHistory,
                deleteHistoryItem: _deleteHistoryItem,
              ),
            ),
          ),
        ),
      ),
    );
  }

//Methods for manipulating the list of Pickables. They call in turn for methods
//in the PickableListProvider class, which notify listeners about changes.
  void initializeList(List<Pickable> list) {
    Provider.of<PickableListProvider>(context, listen: false)
        .setPickableList(list);
  }

  void _createPickable(Pickable pickable) {
    Provider.of<PickableListProvider>(context, listen: false)
        .addPickableListItem(pickable);
    Navigator.pop(context);
  }

  void _deleteItem(Pickable item) {
    Provider.of<PickableListProvider>(context, listen: false)
        .removePickableListItem(item);
  }

  void _addToHistory(Pickable item, PickableHistory historyItem) {
    Provider.of<PickableListProvider>(context, listen: false)
        .addHistoryItem(item, historyItem);
  }

  void _updateHistory(
      Pickable pickable, PickableHistory historyItem, int index) {
    Provider.of<PickableListProvider>(context, listen: false)
        .updateHistoryItem(pickable, historyItem, index);
  }

  void _deleteHistoryItem(Pickable pickable, PickableHistory history) {
    Provider.of<PickableListProvider>(context, listen: false)
        .removePickableHistoryItem(pickable, history);
  }

  void _savePlace(Place place) {
    Provider.of<MyLocations>(context, listen: false).addPlace(place);
    Navigator.pop(context);
  }

  void getAndSetPlaces(list) async {
    Provider.of<MyLocations>(context, listen: false).setPlaceList(list);
  }

  void _deletePlace(Place place) {
    Provider.of<MyLocations>(context, listen: false).deletePlace(place);
  }

  AlertDialog showAlertDialog(
      BuildContext context, Pickable pickable, ThemeData theme) {
    String item = pickable.name;
    return AlertDialog(
      title: Text("Poista $item"),
      content: const Text("Haluatko poistaa kohteen ja kaikki sen tiedot?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            "Poista",
            style: theme.textTheme.bodyText2,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            "Peruuta",
            style: theme.textTheme.bodyText2,
          ),
        ),
      ],
    );
  }

//Open a modal bottom sheet for entering a new name and changing the unit.
  editName(BuildContext context, List<Pickable> pickableItemsList, int index) {
    showModalBottomSheet(
      context: context,
      builder: (builderCtx) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: ChangeName(list: pickableItemsList, index: index),
        );
      },
    );
  }
}
