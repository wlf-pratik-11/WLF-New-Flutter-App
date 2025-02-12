import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';

import '../../../commons/common_functions.dart';
import '../../../commons/my_colors.dart';
import 'firebase_add_phone_screen_dl.dart';

class FirebaseAddPhoneScreenBloc {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref("WLFFlutterNewApp");

  final formKey = GlobalKey<FormState>();

  final radioSelectedValueController = BehaviorSubject<int>.seeded(0);
  final switchValueController = BehaviorSubject<bool>.seeded(false);
  final currentVariantListController = BehaviorSubject<List<String>>();
  final variantValidatorController = BehaviorSubject<bool>.seeded(false);
  final offerPrice = BehaviorSubject<int>.seeded(0);

  final phoneNameController = TextEditingController();
  final priceController = TextEditingController();
  final imgUrlController = TextEditingController();
  final offerTitleController = TextEditingController();
  final offerDescController = TextEditingController();
  final offerPercentageController = TextEditingController();

  List<String> variants = ["64 GB", "128 GB", "256 GB", "512 GB", "1 TB"];
  List<String> currentVariants = [];

  addListData() => currentVariantListController.sink.add(currentVariants);

  Future<void> saveData(BuildContext context, {String? itemKey}) async {
    currentVariants.sort(
      (a, b) {
        int element1 = int.parse(a.replaceAll(" GB", "").replaceAll(" TB", ""));
        int element2 = int.parse(b.replaceAll(" GB", "").replaceAll(" TB", ""));

        return element1.compareTo(element2);
      },
    );

    String isTB = variants.firstWhere((String element) {
      return element.contains("TB");
    });

    if (isTB.trim().isNotEmpty) {
      variants.remove(isTB);
      variants.add(isTB);
    }

    FirebaseAddPhoneScreenDl phoneData = FirebaseAddPhoneScreenDl(
        phoneName: phoneNameController.text,
        imgURL: imgUrlController.text,
        price: priceController.text,
        inStock: radioSelectedValueController.value == 1 ? true : false,
        storageVariant: currentVariants,
        inOffer: switchValueController.value,
        offerTitle: offerTitleController.text,
        offerDescription: offerDescController.text,
        offerPercentage: offerPercentageController.text,
        offerPrice: offerPrice.value.toString());

    DateTime now = DateTime.now();
    String key = "${now.year}${now.month}${now.day}${now.microsecond}";

    final Future<void> operation =
        itemKey != null ? dbRef.child(itemKey).update(phoneData.toJson()) : dbRef.child(key).set(phoneData.toJson());

    await operation;
    if (context.mounted) {
      showSnakbar(context, itemKey != null ? StringValues.updatedSuccessfully : StringValues.savedSuccessfully);
    }
    if (context.mounted) Navigator.pop(context);
  }

  void getData(String itemKey) async {
    DatabaseEvent event = await dbRef.child(itemKey).once();
    DataSnapshot snapshot = event.snapshot;

    final data = FirebaseAddPhoneScreenDl.fromJson(snapshot.value);
    phoneNameController.text = data.phoneName.toString();
    imgUrlController.text = data.imgURL.toString();
    priceController.text = data.price.toString();
    radioSelectedValueController.sink.add(data.inStock == true ? 1 : 0);
    currentVariants.addAll(data.storageVariant ??
        [].map(
          (e) {
            return e;
          },
        ));
    currentVariantListController.sink.add(currentVariants);
    switchValueController.sink.add(data.inOffer ?? false);
    offerTitleController.text = data.offerTitle.toString();
    offerDescController.text = data.offerDescription.toString();
    offerPercentageController.text = data.offerPercentage.toString();
    offerPrice.sink.add(int.parse(data.offerPrice.toString()));
  }

  String? phoneNameValidator(String value) {
    if (value.isEmpty) {
      return "Enter Phone Name";
    } else if (value.length < 5 || value.length > 50) {
      return "Enter Valid Phone Name";
    } else {
      return null;
    }
  }

  String? priceValidator(String value) {
    if (value.isEmpty) {
      return "Enter Phone Price";
    } else {
      return null;
    }
  }

  String? imgUrlValidator(String value) {
    if (value.isEmpty) {
      return "Enter Image URL";
    } else if (value.length > 400) {
      return "Enter Valid Image URL";
    } else {
      return null;
    }
  }

  void variantValidator() {
    if (currentVariants.isEmpty) {
      variantValidatorController.sink.add(true);
    } else {
      variantValidatorController.sink.add(false);
    }
  }

  String? offerTitleValidator(String value) {
    if (switchValueController.value == true) {
      if (value.isEmpty) {
        return "Enter Offer Title";
      } else if (value.length > 50) {
        return "Enter Valid Offer Title";
      } else {
        return null;
      }
    }
    return null;
  }

  String? offerDescValidator(String value) {
    if (switchValueController.value == true) {
      if (value.isEmpty) {
        return "Enter Offer Description";
      } else if (value.length > 50) {
        return "Enter Valid Offer Description";
      } else {
        return null;
      }
    }
    return null;
  }

  String? offerPercentageValidator(String value) {
    if (switchValueController.value == true) {
      if (value.isEmpty) {
        return "Enter Offer Title";
      } else if (value.length > 50) {
        return "Enter Valid Offer Title";
      } else {
        return null;
      }
    }
    return "";
  }

  bool validateForm() {
    variantValidator();
    if (formKey.currentState?.validate() ?? false) {
      return true;
    } else {
      return false;
    }
  }

  void offerPrizeCalculation() {
    if (priceController.text.isNotEmpty && offerPercentageController.text.isNotEmpty) {
      int price = int.parse(priceController.text);
      int perc = int.parse(offerPercentageController.text);
      int offerPrice = price * perc ~/ 100;
      this.offerPrice.sink.add(price - offerPrice);
    }
  }

  showSnakbar(BuildContext context, String title) {
    if (!context.mounted) return;
    var snakBar = SnackBar(
      content: Text(
        "Record Saved Successfully..!!",
        style: TextStyle(color: MyColors.darkBlue, fontSize: screenSizeRatio * 0.02, fontWeight: FontWeight.bold),
      ),
      backgroundColor: MyColors.lightBlue,
    );
    ScaffoldMessenger.of(context).showSnackBar(snakBar);
  }
}
