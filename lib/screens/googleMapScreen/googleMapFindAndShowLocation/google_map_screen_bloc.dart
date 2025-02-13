import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/screens/googleMapScreen/location_latlng_dl.dart';
import 'package:wlf_new_flutter_app/screens/googleMapScreen/saved_address_dl.dart';

import '../location_detail_screen_dl.dart';

class GoogleMapScreenBloc {
  GoogleMapScreenBloc(this.context, bool? fromSavedAddress,SavedAddressDl? savedAddressDl) {
    fromSavedAddress ?? getCurrentLocation();
    getCurrentLocation();
    this.savedAddressDl = savedAddressDl;
    searchLocationInputFieldController.text = jsonDecode(pref.getString("confirmLocation")??"")["address"]??"";
  }
  final BuildContext context;

  var dio = Dio();
  var uuid = Uuid();
  SavedAddressDl? savedAddressDl;
  LatLng currentLocation = LatLng(22.2516503, 22.2516503);
  late SharedPreferences pref;
  String apiKey = "AIzaSyBGJ8mEq1C8Kn4mWY-ds6jDfsr7O8-JNGk";

  final searchLocationInputFieldController = TextEditingController();
  late GoogleMapController mapController;

  final showSuggestionsController = BehaviorSubject<bool>.seeded(false);
  final suggestionsListController = BehaviorSubject<List<Predictions>>();
  final confirmLocationController = BehaviorSubject<String>();

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  Future<void> getCurrentLocation() async {
    await checkPermission();
    final location = await Geolocator.getCurrentPosition();
    currentLocation = LatLng(location.latitude, location.longitude);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLocation,
          zoom: 16.0,
        ),
      ),
    );
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemark.isNotEmpty) {
        Placemark place = placemark.first;
        String address =
            "${place.name},${place.thoroughfare},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}";
        searchLocationInputFieldController.text = address;
        savedAddressDl = SavedAddressDl(latLng: [location.latitude, location.longitude, address]);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<Predictions>> getSuggestions(String input) async {
    final sessionToken = uuid.v4();
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$apiKey&sessiontoken=$sessionToken';
    var response = await dio.get(request);
    if (response.statusCode == 200) {
      final data = LocationDetailScreenDl.fromJson(response.data);
      List<Predictions>? addressList = data.predictions;
      suggestionsListController.sink.add(addressList ?? []);
    } else {
      debugPrint('Failed to load predictions');
    }
    return [];
  }

  void saveAddressInTextFormField(String? value) {
    searchLocationInputFieldController.text = value ?? "";
    showSuggestionsController.sink.add(false);
  }

  Future<void> navigateToLocation(String? placeID, String? placeIDAddress) async {
    String url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=$apiKey";
    var response = await dio.get(url);

    if (response.statusCode == 200) {
      var data = response.data["result"]["geometry"]["location"];
      final latLon = LocationLatLonDl.fromJson(data);
      currentLocation = LatLng(latLon.lat ?? 0, latLon.lng ?? 0);
      searchLocationInputFieldController.text = placeIDAddress ?? "";
      savedAddressDl = SavedAddressDl(latLng: [currentLocation.latitude, currentLocation.longitude], address: placeIDAddress);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocation,
            zoom: 16.0,
          ),
        ),
      );
    } else {
      debugPrint("Error");
    }
  }

  Future<bool> checkPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  confirmLocation() async {
    if (savedAddressDl?.address != null) {
      if (context.mounted) {
        print("Comfirm address from search field:::${savedAddressDl?.address}");
        Navigator.pop(context);
        navigatorPop(context);
      }
    }
  }

  getCameraLocation() async {
    Future<LatLng> latLng =
        mapController.getLatLng(ScreenCoordinate(x: (screenSize!.height / 2).toInt(), y: (screenSize!.width / 2).toInt()));
    latLng.then(
      (value) async {
        try {
          List<Placemark> placemark = await placemarkFromCoordinates(
            value.latitude,
            value.longitude,
          );
          if (placemark.isNotEmpty) {
            Placemark place = placemark.first;
            String address =
                "${place.name},${place.thoroughfare},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}";
            debugPrint("Get Location On Camera Move:::::::$address");
            savedAddressDl = SavedAddressDl(latLng: [value.latitude, value.longitude], address: address);
            searchLocationInputFieldController.text = address;
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      },
    );
  }
}
