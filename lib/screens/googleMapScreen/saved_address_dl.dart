import 'package:google_maps_flutter/google_maps_flutter.dart';

class SavedAddressDl {
  LatLng latLng;
  String address;

  SavedAddressDl(this.latLng, this.address);

  Map<String, dynamic> toJson() {
    return {
      "address": address,
      "lat": latLng.latitude,
      "lng": latLng.longitude,
    };
  }

  factory SavedAddressDl.fromJson(Map<String, dynamic> json) {
    return SavedAddressDl(
      LatLng(json["lat"], json["lng"]),
      json["address"],
    );
  }
}
