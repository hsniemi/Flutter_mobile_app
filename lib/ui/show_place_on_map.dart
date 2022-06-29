import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../model/location.dart';

/*
This class shows the selected place on map and also 
shows and tracks the current location of the user.
*/

class ShowPlaceOnMap extends StatefulWidget {
  const ShowPlaceOnMap({Key? key, required this.place}) : super(key: key);
  final Place place;

  @override
  State<ShowPlaceOnMap> createState() => _ShowPlaceOnMapState();
}

class _ShowPlaceOnMapState extends State<ShowPlaceOnMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Location? location;
  LocationData? currentLocation;
  late StreamSubscription<LocationData> locationSubscription;

  @override
  void initState() {
    super.initState();
    location = Location();

    locationSubscription =
        location!.onLocationChanged.listen((LocationData location) {
      setState(() {
        currentLocation = location;
      });
    });

    setInitialLocation();
  }

  @override
  void dispose() {
    locationSubscription.cancel();
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
        title: const Text('Paikka kartalla'),
      ),
      //Create a map view with markers showing selected place location
      //and users current location.
      body: currentLocation != null
          ? GoogleMap(
              markers: {
                Marker(
                  markerId: MarkerId(widget.place.title),
                  infoWindow: InfoWindow(
                    title: widget.place.title,
                    snippet: widget.place.date,
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueViolet),
                  position:
                      LatLng(widget.place.latitude, widget.place.longitude),
                ),
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  infoWindow: const InfoWindow(
                    title: 'Nykyinen sijaintisi',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                  position: currentLocation != null
                      ? LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!)
                      : const LatLng(0.0, 0.0),
                )
              },
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.place.latitude, widget.place.longitude),
                zoom: 16.0,
              ),
            )
          : Container(
              height: 400,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              ),
            ),
    );
  }
}
