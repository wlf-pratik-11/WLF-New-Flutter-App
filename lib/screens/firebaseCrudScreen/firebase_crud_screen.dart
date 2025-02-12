import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/firebaseCrudScreen/firebaseAddPhoneScreen/firebase_add_phone_screen.dart';
import 'package:wlf_new_flutter_app/screens/firebaseCrudScreen/firebase_crud_screen_bloc.dart';

import 'firebase_crud_screen_dl.dart';

class FirebaseCrudScreen extends StatefulWidget {
  const FirebaseCrudScreen({super.key});

  @override
  State<FirebaseCrudScreen> createState() => _FirebaseCrudScreenState();
}

class _FirebaseCrudScreenState extends State<FirebaseCrudScreen> {
  late FirebaseCrudScreenBloc _bloc;
  late FirebaseCrudScreenDl screenData;

  @override
  void didChangeDependencies() {
    _bloc = FirebaseCrudScreenBloc();
    screenData = FirebaseCrudScreenDl();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(StringValues.firebaseCrudScreen, actions: [
        IconButton(
          onPressed: () => navigatorPush(context, FirebaseAddPhoneScreen()),
          icon: Icon(Icons.add_box_outlined),
          padding: paddingSymmetric(horizontal: 0.03),
        )
      ]),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return FirebaseAnimatedList(
      physics: BouncingScrollPhysics(),
      query: _bloc.getFirebaseRef(),
      itemBuilder: (context, snapshot, animation, index) {
        screenData = FirebaseCrudScreenDl.fromJson(snapshot.value);
        return Dismissible(
          background: Container(
            padding: paddingSymmetric(horizontal: 0.025),
            alignment: Alignment.centerLeft,
            color: MyColors.lightBlue,
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  size: screenSizeRatio * 0.04,
                  color: MyColors.darkBlue,
                ),
                Text(
                  StringValues.delete,
                  style: TextStyle(color: MyColors.darkBlue, fontWeight: FontWeight.bold, fontSize: screenSizeRatio * 0.035),
                )
              ],
            ),
          ),
          key: UniqueKey(),
          direction: DismissDirection.startToEnd,
          confirmDismiss: (direction) async {
            return await _bloc.deleteItemFromList(snapshot.key ?? "", context);
          },
          child: InkWell(
            child: cardForFirebaseAnimatedList(snapshot: snapshot, index: index, screenData: screenData),
            onLongPress: () => navigatorPush(
                context,
                FirebaseAddPhoneScreen(
                  itemKey: snapshot.key,
                )),
          ),
        );
      },
    );
  }

  Widget cardForFirebaseAnimatedList(
      {required DataSnapshot snapshot, required int index, required FirebaseCrudScreenDl screenData}) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(5)),
      margin: paddingSymmetric(vertical: 0.01, horizontal: 0.015),
      child: Padding(
        padding: EdgeInsets.all(screenSizeRatio * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [cardLeftPart(screenData: screenData), cardRightPart(screenData: screenData)],
        ),
      ),
    );
  }

  Widget cardLeftPart({required FirebaseCrudScreenDl screenData}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.network(
            screenData.imgURL.toString(),
            height: screenSizeRatio * 0.25,
            width: screenSizeRatio * 0.25,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              }
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(seconds: 2),
                curve: Curves.easeOut,
                child: child,
              );
            },
          ),
          SizedBox(
            height: screenSizeRatio * 0.03,
          ),
          addOnInfoRow(assetImagePath: "assets/images/localshipping.png", description: StringValues.freeDelivery),
          addOnInfoRow(assetImagePath: "assets/images/verified.png", description: StringValues.yearWarranty),
          addOnInfoRow(assetImagePath: "assets/images/brand.png", description: StringValues.topBrand)
        ],
      ),
    );
  }

  Widget cardRightPart({required FirebaseCrudScreenDl screenData}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: paddingSymmetric(vertical: 0.01),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    screenData.phoneName.toString(),
                    softWrap: true,
                    maxLines: 5,
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: screenSizeRatio * 0.03, fontWeight: FontWeight.w700, color: MyColors.mainColor),
                  ),
                ),
                Container(
                  margin: paddingSymmetric(horizontal: 0.02),
                  decoration: BoxDecoration(
                      color: screenData.inStock == true
                          ? CupertinoColors.systemGreen.withOpacity(0.2)
                          : CupertinoColors.destructiveRed.withOpacity(0.2),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadiusDirectional.circular(5)),
                  child: Padding(
                    padding: paddingSymmetric(vertical: 0.008, horizontal: 0.009),
                    child: Text(
                      screenData.inStock == true ? StringValues.inStock : StringValues.stockOut,
                      style: TextStyle(
                          color: screenData.inStock == true ? Colors.green : Colors.red,
                          fontSize: screenSizeRatio * 0.02,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: paddingSymmetric(vertical: 0.01),
            child: Text(
              "₹ ${screenData.price.toString()}",
              style: TextStyle(
                fontSize: screenSizeRatio * 0.03,
                fontWeight: FontWeight.w500,
                color: MyColors.mainColor,
              ),
            ),
          ),
          RichText(
              overflow: TextOverflow.fade,
              text: TextSpan(children: [
                TextSpan(
                    style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                      fontSize: screenSizeRatio * 0.025,
                      fontWeight: FontWeight.w700,
                      color: Colors.orange,
                    )),
                    text: "Offer price : "),
                TextSpan(
                    style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                      fontSize: screenSizeRatio * 0.025,
                      fontWeight: FontWeight.w700,
                      color: Colors.orange,
                    )),
                    text: "₹ ${screenData.offerPrice.toString()}"),
              ])),
          Padding(
            padding: paddingSymmetric(vertical: 0.01),
            child: Wrap(
              children: screenData.storageVariant?.map(
                    (e) {
                      return variantContainer(e);
                    },
                  ).toList() ??
                  [],
            ),
          ),
          Padding(
            padding: paddingSymmetric(vertical: 0.01),
            child: Text(
              screenData.inOffer == true
                  ? "${screenData.offerTitle} ${screenData.offerDescription} ${screenData.offerPercentage}%"
                  : StringValues.getTheBestDeals,
              style: TextStyle(fontWeight: FontWeight.w700, color: MyColors.offerTextColor, fontSize: screenSizeRatio * 0.025),
              maxLines: 5,
            ),
          ),
          Padding(
            padding: paddingSymmetric(vertical: 0.01),
            child: commonElevatedIconButton(
              title: StringValues.addToCart,
              leading: Image.asset(
                "assets/images/addToCart.png",
                width: screenSizeRatio * 0.035,
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  Widget addOnInfoRow({required String assetImagePath, required String description}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: paddingSymmetric(horizontal: 0.004, vertical: 0.004),
          margin: paddingSymmetric(horizontal: 0.01, vertical: 0.005),
          decoration: BoxDecoration(
            border: Border.all(color: MyColors.darkBlue),
            borderRadius: BorderRadiusDirectional.circular(100),
          ),
          child: Padding(
            padding: EdgeInsets.all(screenSizeRatio * 0.005),
            child: Image.asset(
              assetImagePath,
              width: screenSizeRatio * 0.03,
            ),
          ),
        ),
        Text(
          description,
          style: TextStyle(color: MyColors.darkBlue, fontSize: screenSizeRatio * 0.025, fontWeight: FontWeight.w700),
        )
      ],
    );
  }

  Widget variantContainer(String varieant) {
    return Container(
      margin: paddingSymmetric(horizontal: 0.008, vertical: 0.005),
      padding: paddingSymmetric(vertical: 0.006, horizontal: 0.012),
      decoration:
          BoxDecoration(color: Colors.black54, shape: BoxShape.rectangle, borderRadius: BorderRadiusDirectional.circular(5)),
      child: Text(
        varieant,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
