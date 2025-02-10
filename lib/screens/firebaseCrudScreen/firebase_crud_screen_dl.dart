/// imgURL : "https://rukminim2.flixcart.com/image/850/1000/xif0q/mobile/1/x/3/-original-imah8pdnxdwzazyy.jpeg?q=90&crop=false"
/// offerPrice : "25076"
/// offerPercentage : "56"
/// offerDescription : "variantOfPhoneSection"
/// price : "56990"
/// inStock : true
/// inOffer : true
/// storageVariant : ["64 GB","1 TB"]
/// phoneName : "Redmi 9 pro max"
/// offerTitle : "10 Fab"

class FirebaseCrudScreenDl {
  FirebaseCrudScreenDl({
      String? imgURL, 
      String? offerPrice, 
      String? offerPercentage, 
      String? offerDescription, 
      String? price, 
      bool? inStock, 
      bool? inOffer, 
      List<String>? storageVariant, 
      String? phoneName, 
      String? offerTitle,}){
    _imgURL = imgURL;
    _offerPrice = offerPrice;
    _offerPercentage = offerPercentage;
    _offerDescription = offerDescription;
    _price = price;
    _inStock = inStock;
    _inOffer = inOffer;
    _storageVariant = storageVariant;
    _phoneName = phoneName;
    _offerTitle = offerTitle;
}

  FirebaseCrudScreenDl.fromJson(dynamic json) {
    _imgURL = json['imgURL'];
    _offerPrice = json['offerPrice'];
    _offerPercentage = json['offerPercentage'];
    _offerDescription = json['offerDescription'];
    _price = json['price'];
    _inStock = json['inStock'];
    _inOffer = json['inOffer'];
    _storageVariant = json['storageVariant'] != null ? json['storageVariant'].cast<String>() : [];
    _phoneName = json['phoneName'];
    _offerTitle = json['offerTitle'];
  }
  String? _imgURL;
  String? _offerPrice;
  String? _offerPercentage;
  String? _offerDescription;
  String? _price;
  bool? _inStock;
  bool? _inOffer;
  List<String>? _storageVariant;
  String? _phoneName;
  String? _offerTitle;

  String? get imgURL => _imgURL;
  String? get offerPrice => _offerPrice;
  String? get offerPercentage => _offerPercentage;
  String? get offerDescription => _offerDescription;
  String? get price => _price;
  bool? get inStock => _inStock;
  bool? get inOffer => _inOffer;
  List<String>? get storageVariant => _storageVariant;
  String? get phoneName => _phoneName;
  String? get offerTitle => _offerTitle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imgURL'] = _imgURL;
    map['offerPrice'] = _offerPrice;
    map['offerPercentage'] = _offerPercentage;
    map['offerDescription'] = _offerDescription;
    map['price'] = _price;
    map['inStock'] = _inStock;
    map['inOffer'] = _inOffer;
    map['storageVariant'] = _storageVariant;
    map['phoneName'] = _phoneName;
    map['offerTitle'] = _offerTitle;
    return map;
  }

}