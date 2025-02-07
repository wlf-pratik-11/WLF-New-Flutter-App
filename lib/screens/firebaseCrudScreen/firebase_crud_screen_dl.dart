/// imgUrl : "https://media-ik.croma.com/prod/https://media.croma.com/image/upload/v1725959668/Croma%20Assets/Communication/Mobiles/Images/309732_0_oxoamu.png?tr=w-600"
/// offer : 59
/// price : 119900
/// name : "Iphone 15 Pro Max"
/// variant : {"third":"256 GB","fifth":"1 TB","fourth":"512 GB","first":"64 GB","second":"128 GB"}
/// inStock : true
/// inOffer : true

class FirebaseCrudScreenDl {
  FirebaseCrudScreenDl({
      String? imgUrl, 
      int? offer, 
      int? price, 
      String? name, 
      Variant? variant, 
      bool? inStock, 
      bool? inOffer,}){
    _imgUrl = imgUrl;
    _offer = offer;
    _price = price;
    _name = name;
    _variant = variant;
    _inStock = inStock;
    _inOffer = inOffer;
}

  FirebaseCrudScreenDl.fromJson(dynamic json) {
    _imgUrl = json['imgUrl'];
    _offer = json['offer'];
    _price = json['price'];
    _name = json['name'];
    _variant = json['variant'] != null ? Variant.fromJson(json['variant']) : null;
    _inStock = json['inStock'];
    _inOffer = json['inOffer'];
  }
  String? _imgUrl;
  int? _offer;
  int? _price;
  String? _name;
  Variant? _variant;
  bool? _inStock;
  bool? _inOffer;

  String? get imgUrl => _imgUrl;
  int? get offer => _offer;
  int? get price => _price;
  String? get name => _name;
  Variant? get variant => _variant;
  bool? get inStock => _inStock;
  bool? get inOffer => _inOffer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imgUrl'] = _imgUrl;
    map['offer'] = _offer;
    map['price'] = _price;
    map['name'] = _name;
    if (_variant != null) {
      map['variant'] = _variant?.toJson();
    }
    map['inStock'] = _inStock;
    map['inOffer'] = _inOffer;
    return map;
  }

}

/// third : "256 GB"
/// fifth : "1 TB"
/// fourth : "512 GB"
/// first : "64 GB"
/// second : "128 GB"

class Variant {
  Variant({
      String? third, 
      String? fifth, 
      String? fourth, 
      String? first, 
      String? second,}){
    _third = third;
    _fifth = fifth;
    _fourth = fourth;
    _first = first;
    _second = second;
}

  Variant.fromJson(dynamic json) {
    _third = json['third'];
    _fifth = json['fifth'];
    _fourth = json['fourth'];
    _first = json['first'];
    _second = json['second'];
  }
  String? _third;
  String? _fifth;
  String? _fourth;
  String? _first;
  String? _second;

  String? get third => _third;
  String? get fifth => _fifth;
  String? get fourth => _fourth;
  String? get first => _first;
  String? get second => _second;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['third'] = _third;
    map['fifth'] = _fifth;
    map['fourth'] = _fourth;
    map['first'] = _first;
    map['second'] = _second;
    return map;
  }

}