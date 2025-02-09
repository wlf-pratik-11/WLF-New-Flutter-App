class FirebaseAddPhoneScreenDl {
  FirebaseAddPhoneScreenDl({
      this.imgURL, 
      this.offerPrice, 
      this.offerPercentage, 
      this.offerDescription, 
      this.price, 
      this.inStock, 
      this.inOffer, 
      this.storageVariant, 
      this.phoneName, 
      this.offerTitle,});

  FirebaseAddPhoneScreenDl.fromJson(dynamic json) {
    imgURL = json['imgURL'];
    offerPrice = json['offerPrice'];
    offerPercentage = json['offerPercentage'];
    offerDescription = json['offerDescription'];
    price = json['price'];
    inStock = json['inStock'];
    inOffer = json['inOffer'];
    storageVariant = json['storageVariant'] != null ? json['storageVariant'].cast<String>() : [];
    phoneName = json['phoneName'];
    offerTitle = json['offerTitle'];
  }
  String? imgURL;
  String? offerPrice;
  String? offerPercentage;
  String? offerDescription;
  String? price;
  bool? inStock;
  bool? inOffer;
  List<String>? storageVariant;
  String? phoneName;
  String? offerTitle;
FirebaseAddPhoneScreenDl copyWith({  String? imgURL,
  String? offerPrice,
  String? offerPercentage,
  String? offerDescription,
  String? price,
  bool? inStock,
  bool? inOffer,
  List<String>? storageVariant,
  String? phoneName,
  String? offerTitle,
}) => FirebaseAddPhoneScreenDl(  imgURL: imgURL ?? this.imgURL,
  offerPrice: offerPrice ?? this.offerPrice,
  offerPercentage: offerPercentage ?? this.offerPercentage,
  offerDescription: offerDescription ?? this.offerDescription,
  price: price ?? this.price,
  inStock: inStock ?? this.inStock,
  inOffer: inOffer ?? this.inOffer,
  storageVariant: storageVariant ?? this.storageVariant,
  phoneName: phoneName ?? this.phoneName,
  offerTitle: offerTitle ?? this.offerTitle,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imgURL'] = imgURL;
    map['offerPrice'] = offerPrice;
    map['offerPercentage'] = offerPercentage;
    map['offerDescription'] = offerDescription;
    map['price'] = price;
    map['inStock'] = inStock;
    map['inOffer'] = inOffer;
    map['storageVariant'] = storageVariant;
    map['phoneName'] = phoneName;
    map['offerTitle'] = offerTitle;
    return map;
  }

}