import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../commons/common_functions.dart';
import '../../commons/my_colors.dart';
import '../../commons/string_values.dart';

class FirebaseCrudScreenBloc {
  FirebaseCrudScreenBloc() {
    getFirebaseRef();
  }

  DatabaseReference ref = FirebaseDatabase.instance.ref("WLFFlutterNewApp");
  final orderPlaced = BehaviorSubject<bool>.seeded(false);

  Query getFirebaseRef() {
    final firebaseReference = ref;
    return firebaseReference;
  }

  deleteItemFromList(String key, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
          backgroundColor: MyColors.mainColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.025),
                child: Text(
                  StringValues.areYouWantToDelete,
                  style: TextStyle(color: Colors.white, fontSize: diologeFontSize, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.02, horizontal: screenSizeRatio * 0.04),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
                            backgroundColor: MyColors.buttonFontColor),
                        onPressed: () async {
                          return deleteItemFromFirebase(key, context);
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

  deleteItemFromFirebase(String itemKey, BuildContext context) async {
    await ref.child(itemKey).remove().then((value) {
      var snakBar = SnackBar(
        content: Text(
          "Deleted Successfully..!!",
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
