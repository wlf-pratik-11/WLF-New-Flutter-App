import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';

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

  addListData() {
    currentVariantListController.sink.add(currentVariants);
  }

  Future<void> saveData(BuildContext context,{String? itemKey}) async {
    FirebaseAddPhoneScreenDl phoneData = FirebaseAddPhoneScreenDl(
        phoneName: phoneNameController.text,
        imgURL: imgUrlController.text,
        price: priceController.text,
        inStock: switchValueController.value,
        storageVariant: currentVariants,
        inOffer: switchValueController.value,
        offerTitle: offerTitleController.text,
        offerDescription: offerDescController.text,
        offerPercentage: offerPercentageController.text,
        offerPrice: offerPrice.value.toString()
    );

    if(itemKey!=null){
      await dbRef
          .child(itemKey??"")
          .update(phoneData.toJson())
          .then(
            (value) {
          var snakBar = SnackBar(
            content: Text(
              "Record Updeted Successfully..!!",
              style: TextStyle(color: Colors.white, fontSize: screenSizeRatio*0.03, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.black,
          );
          if(context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(snakBar);
          }
        },
      );
    }else{
      DateTime now = DateTime.now();
      String key = "${now.year}${now.month}${now.day}${now.microsecond}";

      await dbRef.child(key).set(phoneData.toJson()).then((_) {
        var snakBar = SnackBar(
          content: Text(
            "Record Saved Successfully..!!",
            style: TextStyle(color: Colors.white, fontSize: screenSizeRatio*0.03, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black,
        );
        if(context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snakBar);
        };
      }).catchError((error) {
        print("Failed to save data: $error");
      });
    }
  }

  void getData(String itemKey) async {
    DatabaseEvent event = await dbRef.child("$itemKey").once();
    DataSnapshot snapshot = event.snapshot;
    print("Map Data =======================>>>>>>>>>>>>>>>${snapshot.value}");
  }

  String phoneNameValidator(String value) {
    if (value.isEmpty) {
      return "Enter Phone Name";
    } else if (value.length < 5 || value.length > 50) {
      return "Enter Valid Phone Name";
    } else {
      return "";
    }
  }

  String priceValidator(String value) {
    if (value.isEmpty) {
      return "Enter Phone Price";
    } else if (value.isEmpty || value.length > 6) {
      return "Enter Valid Phone Price";
    } else {
      return "";
    }
  }

  String imgUrlValidator(String value) {
    if (value.isEmpty) {
      return "Enter Image URL";
    } else if (value.isEmpty || value.length >400) {
      return "Enter Valid Image URL";
    } else {
      return "";
    }
  }

  void variantValidator() {
    if (currentVariants.isEmpty) {
      variantValidatorController.sink.add(true);
    } else {
      variantValidatorController.sink.add(false);
    }
  }

  String offerTitleValidator(String value) {
    if (switchValueController.value == true) {
      if (value.isEmpty) {
        return "Enter Offer Title";
      } else if (value.isEmpty || value.length > 50) {
        return "Enter Valid Offer Title";
      } else {
        return "";
      }
    }
    return "";
  }

  String offerDescValidator(String value) {
    if (switchValueController.value == true) {
      if (value.isEmpty) {
        return "Enter Offer Description";
      } else if (value.isEmpty || value.length > 50) {
        return "Enter Valid Offer Description";
      } else {
        return "";
      }
    }
    return "";
  }

  String offerPercentageValidator(String value) {
    if (switchValueController.value == true) {
      if (value.isEmpty) {
        return "Enter Offer Title";
      } else if (value.isEmpty || value.length > 50) {
        return "Enter Valid Offer Title";
      } else {
        return "";
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
}
