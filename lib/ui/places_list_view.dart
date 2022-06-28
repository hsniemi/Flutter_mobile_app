import 'package:flutter/material.dart';
import 'package:flutter_app_summer_project/db/pickable_database.dart';
import 'package:flutter_app_summer_project/providers/my_locations.dart';
import 'package:flutter_app_summer_project/ui/map_view.dart';
import 'package:flutter_app_summer_project/ui/show_place_on_map.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/location.dart';

/*
This class displays the list of places saved into the devise by the user.
*/

class PlacesListView extends StatelessWidget {
  const PlacesListView(
      {Key? key, required this.deletePlace, required this.savePlace})
      : super(key: key);
  final Function deletePlace;
  final Function savePlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Omat keräilypaikat'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapView(onSavePlace: savePlace),
                ),
              ),
              icon: const Icon(
                Icons.add_circle_rounded,
              ),
            ),
          ),
        ],
      ),
      //Using Consumer class to listen for changes in the place list provided by MyLocations class.
      body: Consumer<MyLocations>(
        child: const Center(
          child: Text('Ei keräilypaikkoja'),
        ),
        builder: (context, myLocations, ch) => myLocations.placeList.isEmpty
            ? Container(child: ch)
            : ListView.builder(
                itemCount: myLocations.placeList.length,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
                  child: ListTile(
                    tileColor: Colors.purple[100],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side:
                            const BorderSide(color: Colors.purple, width: 2.0)),
                    title: Text(myLocations.placeList[index].title,
                        style: Theme.of(context).textTheme.headline2),
                    subtitle: myLocations.placeList[index].description == null
                        ? null
                        : Text(
                            myLocations.placeList[index].description!,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                    //Removes the item from database when icon button is pressed.
                    leading: IconButton(
                      onPressed: () =>
                          _deleteItem(myLocations.placeList[index]),
                      icon: const Icon(Icons.delete_forever_rounded),
                      color: Colors.orangeAccent.shade700,
                    ),
                    //Opens a map view to show place location and current user location
                    //when icon button is pressed.
                    trailing: IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) => ShowPlaceOnMap(
                              place: myLocations.placeList[index])),
                        ),
                      ),
                      icon: const FaIcon(FontAwesomeIcons.mapLocationDot,
                          size: 30),
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
      ),
      //),
    );
  }

  _deleteItem(Place place) async {
    await PickableDatabase.instance.deletePlace(place.id!);
    deletePlace(place);
  }
}
