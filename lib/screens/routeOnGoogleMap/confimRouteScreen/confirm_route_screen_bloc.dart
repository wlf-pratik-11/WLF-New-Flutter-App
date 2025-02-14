import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:rxdart/rxdart.dart';

import '../../googleMapScreen/saved_address_dl.dart';

class ConfirmRouteScreenBloc {
  final BuildContext context;

  ConfirmRouteScreenBloc(this.context, this.origin, this.destination) {
    getCurrentLocation();
    addMarker(LatLng(origin.latLng?[0], origin.latLng?[1]), "origin", BitmapDescriptor.defaultMarker);
    addMarker(LatLng(destination.latLng?[0], destination.latLng?[1]), "destination", BitmapDescriptor.defaultMarkerWithHue(90));
    getPolyline();
  }

  late GoogleMapController mapController;
  SavedAddressDl? savedAddressDl = SavedAddressDl();
  SavedAddressDl origin = SavedAddressDl();
  SavedAddressDl destination = SavedAddressDl();
  LatLng currentLocation = LatLng(22.2516503, 25.2516503);
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  final polyLinesController = BehaviorSubject<Map<PolylineId, Polyline>>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String apiKey = "AIzaSyBGJ8mEq1C8Kn4mWY-ds6jDfsr7O8-JNGk";

  MapsRoutes route = new MapsRoutes();

  onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  Future<void> getCurrentLocation() async {
    await checkPermission();
    final location = await Geolocator.getCurrentPosition();
    currentLocation = LatLng(origin.latLng?[0], origin.latLng?[1]);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLocation,
          zoom: 14.5,
        ),
      ),
    );
  }

  Future<void> getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey, PointLatLng(origin.latLng?[0], origin.latLng?[1]), PointLatLng(destination.latLng?[0], destination.latLng?[1]));
    debugPrint("Polyline points::::::::::::::::${result.points}");
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    addPolyLine();
  }

  addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: Color.fromRGBO(236, 13, 61, 1.0), points: polylineCoordinates);
    polylines[id] = polyline;
    polyLinesController.sink.add(polylines);
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
}
