import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../commons/common_functions.dart';
import '../../commons/my_colors.dart';
import '../../commons/string_values.dart';

class FirebaseCrudScreenBloc {
  final BuildContext context;
  FirebaseCrudScreenBloc(this.context) {
    getFirebaseRef();
  }

  DatabaseReference ref = FirebaseDatabase.instance.ref("WLFFlutterNewApp");
  final orderPlaced = BehaviorSubject<bool>.seeded(false);

  Query getFirebaseRef() {
    return ref;
  }

  deleteItemFromList(String key) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(screenSizeRatio*0.01)),
          backgroundColor: MyColors.mainColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: paddingSymmetric(vertical: 0.025),
                child: Text(
                  StringValues.areYouWantToDelete,
                  style: TextStyle(color: Colors.white, fontSize: diologeFontSize, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: paddingSymmetric(vertical: 0.02, horizontal:  0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          StringValues.cancel,
                          style: TextStyle(color: Colors.white, fontSize: diologeButtonFontSize),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(screenSizeRatio*0.01)),
                            backgroundColor: MyColors.buttonFontColor),
                        onPressed: () async {
                          return deleteItemFromFirebase(key);
                        },
                        child: Text(
                          StringValues.delete,
                          style: TextStyle(color: MyColors.mainColor, fontSize: diologeButtonFontSize),
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  deleteItemFromFirebase(String itemKey) async {
    await ref.child(itemKey).remove().then((value) {
      var snakBar = SnackBar(
        content: Text(
          StringValues.deletedSuccessfully,
          style: TextStyle(color: Colors.white, fontSize: screenSizeRatio * 0.03, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snakBar);
        Navigator.pop(context);
      }
    });
  }
}
