/// latLng : [22.3190469,70.7671092]
/// address : "150 Feet Ring Road,150 Feet Ring Road,Dharam Nagar Society, Rajkot, 360006, Gujarat"

class SavedAddressDl {
  SavedAddressDl({
    List<dynamic>? latLng,
    String? address,
  }) {
    _latLng = latLng;
    _address = address;
  }

  SavedAddressDl.fromJson(dynamic json) {
    _latLng = json['latLng'] != null ? json['latLng'].cast<dynamic>() : [];
    _address = json['address'];
  }
  List<dynamic>? _latLng;
  String? _address;

  List<dynamic>? get latLng => _latLng;
  String? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latLng'] = _latLng;
    map['address'] = _address;
    return map;
  }
}
