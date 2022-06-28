import 'dart:async';

import 'package:flutter_app_summer_project/db/pickable_database.dart';
import 'package:flutter_app_summer_project/model/location.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

import '../themes/custom_theme.dart';

/*
This class uses Google Maps API to show a map view tracking the users location.
*/

class MapView extends StatefulWidget {
  const MapView({Key? key, required this.onSavePlace}) : super(key: key);
  final Function onSavePlace;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Location? location;
  LocationData? currentLocation;
  final Completer<GoogleMapController> _controller = Completer();
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();

  late StreamSubscription<LocationData> locationSubscription;
  bool _titleValid = true;

  @override
  initState() {
    super.initState();
    location = Location();

//Subscribe to a stream of location data and update the currentLocation variable,
//which holds the current location of the user.
    locationSubscription =
        location!.onLocationChanged.listen((LocationData location) {
      setState(() {
        currentLocation = location;
      });
    });
    setInitialLocation(); //Get and set the initial location of the user.
  }

  @override
  void dispose() {
    locationSubscription
        .cancel(); //Cancel subscription to location stream when this view is closed.
    super.dispose();
  }

  void setInitialLocation() async {
    currentLocation = await location!.getLocation();
    setState(() {
      currentLocation = currentLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sijaintisi'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //Show location on map if location information is available.
                  currentLocation != null
                      ? _buildGoogleMap(context, currentLocation!.latitude!,
                          currentLocation!.longitude!)
                      : Container(
                          height: 400,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.purple,
                            ),
                          ),
                        ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Otsikko',
                        hintStyle:
                            Theme.of(context).textTheme.headline2!.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                        enabledBorder: CustomInputTheme.border(),
                        focusedBorder: CustomInputTheme.border(width: 2.0),
                        errorBorder: CustomInputTheme.border(color: Colors.red),
                        focusedErrorBorder: CustomInputTheme.border(
                            color: Colors.red, width: 2.0),
                        errorText: !_titleValid ? 'Otsikko puuttuu!' : null,
                        labelText: 'Otsikko',
                        labelStyle: CustomInputTheme.inputTextStyle(),
                      ),
                      style: CustomInputTheme.inputTextStyle(),
                      controller: _titleController,
                      maxLines: 1,
                      onSubmitted: (_) => _saveLocationInfo(context),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Kuvaus',
                        hintStyle: CustomInputTheme.inputTextStyle(),
                        labelText: 'Kuvaus',
                        labelStyle: CustomInputTheme.inputTextStyle(),
                        enabledBorder: CustomInputTheme.border(),
                        focusedBorder: CustomInputTheme.border(width: 2.0),
                      ),
                      style: CustomInputTheme.inputTextStyle(),
                      controller: _descriptionController,
                      maxLines: 3,
                      onSubmitted: (_) => _saveLocationInfo(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: ElevatedButton(
              onPressed: () => _saveLocationInfo(context),
              child: const Text(
                'Tallenna paikkatieto',
              ),
            ),
          ),
        ],
      ),
    );
  }

  _saveLocationInfo(BuildContext context) async {
    setState(() {
      _titleValid = true; //Initialize _titleValid as true.
    });
    final description = _descriptionController.text;
    final title = _titleController.text;
    _validateTitle(title); //Check that title field is not empty.
    if (currentLocation != null && _titleValid == true) {
      Place place = Place(
        //Create a new Place object with given title and description.
        date: DateTime.now().toString(),
        title: title,
        description: description,
        latitude: currentLocation!.latitude!,
        longitude: currentLocation!.longitude!,
      );
      //Insert the new place into database and store the returned Place object
      //with id into the variable createdPlace.
      final createdPlace = await PickableDatabase.instance.createPlace(place);
      //Call _savePlace method in home.dart to add cratedPlace to the provider list.
      widget.onSavePlace(createdPlace);
    }
  }

  void _validateTitle(String title) {
    if (title == "") {
      setState(() {
        _titleValid = false;
      });
    }
  }

//Build a Google map view with marker showing current location.
  Widget _buildGoogleMap(BuildContext context, double lat, double long) {
    print('buildGoogleMap: $lat, $long');
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 400,
      child: GoogleMap(
        markers: {
          Marker(
            markerId: const MarkerId('Sijaintisi'),
            infoWindow: const InfoWindow(
                title: 'Sijaintisi', snippet: 'Tämänhetkinen sijaintisi.'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
            position: LatLng(lat, long),
          ),
        },
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, long),
          zoom: 16.0,
        ),
      ),
    );
  }
}
