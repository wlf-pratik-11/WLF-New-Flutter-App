import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseAddPhoneScreenBloc {
  final formKey = GlobalKey<FormState>();

  final radioSelectedValueController = BehaviorSubject<int>.seeded(0);
  final switchValueController = BehaviorSubject<bool>.seeded(false);
  final currentVariantListController = BehaviorSubject<List<String>>();
  final variantValidatorController = BehaviorSubject<bool>.seeded(false);
  final offerPrice = BehaviorSubject<int>.seeded(0);

  final phoneNameController = TextEditingController();
  final priceController = TextEditingController();
  final offerTitleController = TextEditingController();
  final offerDescController = TextEditingController();
  final offerPercentageController = TextEditingController();
  List<String> variants = ["64 GB", "128 GB", "256 GB", "512 GB", "1 TB"];
  List<String> currentVariants = [];

  addListData() {
    currentVariantListController.sink.add(currentVariants);
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
    } else if (value.length < 1 || value.length > 6) {
      return "Enter Valid Phone Price";
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
      } else if (value.length < 1 || value.length > 50) {
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
      } else if (value.length < 1 || value.length > 50) {
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
      } else if (value.length < 1 || value.length > 50) {
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
      int offerPrice = (price * perc / 100).toInt();
      print("offerPrice::::::::::::::::::${offerPrice}");
      this.offerPrice.sink.add(price - offerPrice);
    }
  }
}
