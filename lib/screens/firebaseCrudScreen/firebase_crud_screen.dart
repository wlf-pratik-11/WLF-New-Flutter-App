import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/firebaseCrudScreen/firebaseAddPhoneScreen/firebase_add_phone_screen.dart';
import 'package:wlf_new_flutter_app/screens/firebaseCrudScreen/firebase_crud_screen_bloc.dart';

class FirebaseCrudScreen extends StatefulWidget {
  const FirebaseCrudScreen({super.key});

  @override
  State<FirebaseCrudScreen> createState() => _FirebaseCrudScreenState();
}

class _FirebaseCrudScreenState extends State<FirebaseCrudScreen> {
  late FirebaseCrudScreenBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = FirebaseCrudScreenBloc();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(StringValues.firebaseCrudScreen, actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FirebaseAddPhoneScreen(),
                ));
          },
          icon: Icon(Icons.add_box_outlined),
          padding: EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.03),
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
        return Dismissible(
            key: Key(snapshot.key ?? 'item_$index'),
          direction: DismissDirection.startToEnd,
          confirmDismiss:(direction) {
            return _bloc.deleteItemFromList(snapshot.key??"",context);
          } ,
            child:
                InkWell(child: cardForFirebaseAnimatedList(snapshot: snapshot, index: index),onLongPress: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => FirebaseAddPhoneScreen(itemKey: snapshot.key,),));
                },),
        );
      },
    );
  }

  Widget cardForFirebaseAnimatedList(
      {required DataSnapshot snapshot, required int index}) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(5)),
      margin: EdgeInsets.symmetric(
          vertical: screenSizeRatio * 0.01,
          horizontal: screenSizeRatio * 0.015),
      child: Padding(
        padding: EdgeInsets.all(screenSizeRatio * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            cardLeftPart(snapshot: snapshot, index: index),
            cardRightPart(snapshot: snapshot, index: index)
          ],
        ),
      ),
    );
  }

  Widget cardLeftPart({required DataSnapshot snapshot, required int index}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.network(
            snapshot.child("imgUrl").value.toString(),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addOnInfoRow(
                  assetImagePath: "assets/images/localshipping.png",
                  description: StringValues.freeDelivery),
              addOnInfoRow(
                  assetImagePath: "assets/images/verified.png",
                  description: StringValues.yearWarranty),
              addOnInfoRow(
                  assetImagePath: "assets/images/brand.png",
                  description: StringValues.topBrand),
            ],
          )
        ],
      ),
    );
  }

  Widget cardRightPart({required DataSnapshot snapshot, required int index}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.01),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    snapshot.child("name").value.toString(),
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        fontSize: screenSizeRatio * 0.03,
                        fontWeight: FontWeight.w700,
                        color: MyColors.mainColor),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: screenSizeRatio * 0.02),
                  decoration: BoxDecoration(
                      color: snapshot.child("inStock").value == true
                          ? CupertinoColors.systemGreen.withOpacity(0.2)
                          : CupertinoColors.destructiveRed.withOpacity(0.2),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadiusDirectional.circular(5)),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenSizeRatio * 0.008,
                          horizontal: screenSizeRatio * 0.009),
                      child: Text(
                        snapshot.child("inStock").value == true
                            ? StringValues.inStock
                            : StringValues.stockOut,
                        style: TextStyle(
                            color: snapshot.child("inStock").value == true
                                ? Colors.green
                                : Colors.red,
                            fontSize: screenSizeRatio * 0.02,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.01),
            child: Row(
              children: [
                Icon(
                  Icons.currency_rupee,
                  color: MyColors.mainColor,
                  size: screenSizeRatio * 0.03,
                ),
                Text(
                  snapshot.child("price").value.toString(),
                  style: TextStyle(
                    fontSize: screenSizeRatio * 0.03,
                    fontWeight: FontWeight.w500,
                    color: MyColors.mainColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.01),
            child: Wrap(
              children: [
                variantContainer("64 GB"),
                variantContainer("128 GB"),
                variantContainer("256 GB"),
                variantContainer("512 GB"),
                variantContainer("1 TB"),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.01),
            child: Text(
              snapshot.child("inOffer").value == true
                  ? "Spacial offer ${snapshot.child("offer").value}% off"
                  : "Get the Best Deals at Unbeatable Prices!",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: MyColors.offerTextColor,
                  fontSize: screenSizeRatio * 0.025),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.01),
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

  Widget addOnInfoRow(
      {required String assetImagePath, required String description}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenSizeRatio * 0.004,
              vertical: screenSizeRatio * 0.004),
          margin: EdgeInsets.symmetric(
              horizontal: screenSizeRatio * 0.01,
              vertical: screenSizeRatio * 0.005),
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
          style: TextStyle(
              color: MyColors.darkBlue,
              fontSize: screenSizeRatio * 0.025,
              fontWeight: FontWeight.w700),
        )
      ],
    );
  }

  Widget variantContainer(String varieant) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: screenSizeRatio * 0.008,
          vertical: screenSizeRatio * 0.005),
      padding: EdgeInsets.symmetric(
          vertical: screenSizeRatio * 0.006,
          horizontal: screenSizeRatio * 0.012),
      decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadiusDirectional.circular(5)),
      child: Text(
        varieant,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
