import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreenBloc {
  GoogleMapScreenBloc() {
    getCurrentLocation();
  }
  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  late LatLng currentLocation;

  late CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(22.22, 55.55),
    zoom: 14.4746,
  );

  Future<Position> getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
    }

    final location = await Geolocator.getCurrentPosition();
    currentLocation = LatLng(location.latitude, location.latitude);

    List<Placemark>? locationAddress =
        await GeocodingPlatform.instance?.placemarkFromCoordinates(location.latitude, location.longitude);
    print("Current Position:::::::$locationAddress");
    return await Geolocator.getCurrentPosition();
  }
}
