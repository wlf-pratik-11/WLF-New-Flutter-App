import 'package:flutter/material.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/firebaseCrudScreen/firebaseAddPhoneScreen/firebase_add_phone_screen_bloc.dart';

class FirebaseAddPhoneScreen extends StatefulWidget {
  final itemKey;

  const FirebaseAddPhoneScreen({this.itemKey, super.key});

  @override
  State<FirebaseAddPhoneScreen> createState() => _FirebaseAddPhoneScreenState();
}

class _FirebaseAddPhoneScreenState extends State<FirebaseAddPhoneScreen> {
  late FirebaseAddPhoneScreenBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = FirebaseAddPhoneScreenBloc();
    widget.itemKey != null ? _bloc.getData(widget.itemKey) : null;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(widget.itemKey != null ? StringValues.updatePhoneDetails : StringValues.addPhoneDetails),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _bloc.formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: StreamBuilder<bool>(
                  stream: _bloc.switchValueController,
                  builder: (context, switchValueSnapshot) {
                    return Padding(
                      padding: EdgeInsets.only(top: screenSizeRatio * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          inputField(
                            StringValues.phoneName,
                            _bloc.phoneNameController,
                            prefix: Icon(
                              Icons.phone_android,
                              color: MyColors.darkBlue,
                            ),
                            validator: (value) {
                              return _bloc.phoneNameValidator(value);
                            },
                          ),
                          inputField(StringValues.imageURL, _bloc.imgUrlController, validator: (value) {
                            return _bloc.imgUrlValidator(value);
                          },
                              prefix: Icon(
                                Icons.link,
                                color: MyColors.darkBlue,
                              )),
                          inputField(StringValues.price, _bloc.priceController,
                              maxLength: 6,
                              onChanged: () {
                                return _bloc.offerPrizeCalculation();
                              },
                              prefix: Icon(
                                Icons.currency_rupee_rounded,
                                color: MyColors.darkBlue,
                              ),
                              validator: (value) {
                                return _bloc.priceValidator(value);
                              },
                              isNumber: true),
                          stockCheckRadio(),
                          variantOfPhoneSection(),
                          offerActiveButton(switchValueSnapshot),
                          if (switchValueSnapshot.data == true)
                            Column(
                              children: offerInputFields(),
                            ),
                          if (switchValueSnapshot.data == true) offerDetailField()
                        ],
                      ),
                    );
                  }),
            ),
          ),
          submitDataButton()
        ],
      ),
    );
  }

  Widget stockCheckRadio() {
    return StreamBuilder<int>(
        stream: _bloc.radioSelectedValueController,
        builder: (context, selectedValueSnapshot) {
          return Padding(
            padding: EdgeInsets.only(left: screenSizeRatio * 0.04, top: screenSizeRatio * 0.01),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${StringValues.stockDetail} : ",
                  style: TextStyle(fontSize: screenSizeRatio * 0.03),
                ),
                Radio(
                  value: 1,
                  groupValue: selectedValueSnapshot.data,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    _bloc.radioSelectedValueController.sink.add(value ?? 1);
                  },
                ),
                Text(
                  StringValues.inStock,
                  style: TextStyle(fontSize: screenSizeRatio * 0.025, color: Colors.green),
                ),
                Radio(
                  value: 0,
                  activeColor: Colors.red,
                  groupValue: selectedValueSnapshot.data,
                  onChanged: (value) {
                    _bloc.radioSelectedValueController.sink.add(value ?? 0);
                  },
                ),
                Text(
                  StringValues.stockOut,
                  style: TextStyle(fontSize: screenSizeRatio * 0.025, color: Colors.red),
                ),
              ],
            ),
          );
        });
  }

  Widget variantOfPhoneSection() {
    return Padding(
      padding: EdgeInsets.only(top: screenSizeRatio * 0.02, bottom: screenSizeRatio * 0.01, left: screenSizeRatio * 0.04),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${StringValues.variant} : ",
            style: TextStyle(fontSize: screenSizeRatio * 0.03),
            maxLines: 3,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: screenSizeRatio * 0.02,
                  direction: Axis.horizontal,
                  children: _bloc.variants.map(
                    (item) {
                      return variantContainer(item);
                    },
                  ).toList(),
                ),
                StreamBuilder(
                  stream: _bloc.variantValidatorController,
                  builder: (context, snapshot) {
                    return snapshot.data == true
                        ? Text(
                            StringValues.choosePhoneVariant,
                            style: TextStyle(color: Colors.red, fontSize: screenSizeRatio * 0.02, fontWeight: FontWeight.w200),
                          )
                        : Container();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget variantContainer(String item) {
    return StreamBuilder<List<String>>(
        stream: _bloc.currentVariantListController,
        builder: (context, snapshot) {
          return InkWell(
            splashFactory: NoSplash.splashFactory,
            child: Container(
              decoration: BoxDecoration(
                  color: snapshot.data != null ? (snapshot.data!.contains(item) ? MyColors.lightBlue : null) : null,
                  border: Border.all(color: MyColors.lightBlue, width: 3),
                  borderRadius: BorderRadiusDirectional.circular(10)),
              padding: paddingSymmetric(horizontal: 0.02, vertical: 0.015),
              margin: paddingSymmetric(vertical: 0.005),
              child: Text(
                item,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            onTap: () {
              if (_bloc.currentVariants.contains(item)) {
                _bloc.currentVariants.remove(item);
                _bloc.addListData();
              } else {
                _bloc.currentVariants.add(item);
                _bloc.addListData();
              }
            },
          );
        });
  }

  Widget offerActiveButton(AsyncSnapshot<bool> switchValueSnapshot) {
    return Padding(
      padding: EdgeInsets.only(left: screenSizeRatio * 0.04, top: screenSizeRatio * 0.015),
      child: Row(
        children: [
          Text(
            "${StringValues.offerActive} : ",
            style: TextStyle(fontSize: screenSizeRatio * 0.03),
          ),
          Switch(
            activeColor: MyColors.darkBlue,
            inactiveTrackColor: MyColors.lightBlue,
            value: switchValueSnapshot.data ?? false,
            onChanged: (value) {
              _bloc.switchValueController.sink.add(value);
            },
          ),
        ],
      ),
    );
  }

  List<Widget> offerInputFields() {
    return [
      inputField(
        StringValues.offerTitle,
        _bloc.offerTitleController,
        prefix: Icon(
          Icons.local_offer_outlined,
          color: MyColors.darkBlue,
        ),
        validator: (value) {
          return _bloc.offerTitleValidator(value);
        },
      ),
      inputField(
        StringValues.offerDescription,
        _bloc.offerDescController,
        prefix: Icon(
          Icons.description_outlined,
          color: MyColors.darkBlue,
        ),
        validator: (value) {
          return _bloc.offerDescValidator(value);
        },
      ),
      inputField(
          StringValues.offerPercentage,
          onChanged: () {
            return _bloc.offerPrizeCalculation();
          },
          maxLength: 2,
          _bloc.offerPercentageController,
          prefix: Icon(
            Icons.percent,
            color: MyColors.darkBlue,
          ),
          validator: (value) {
            return _bloc.offerPercentageValidator(value);
          },
          isNumber: true)
    ];
  }

  Widget offerDetailField() {
    return Card(
      color: Colors.white,
      elevation: 5,
      margin: paddingSymmetric(vertical: 0.02, horizontal: 0.04),
      child: Padding(
        padding: paddingSymmetric(horizontal: 0.02, vertical: 0.025),
        child: Row(
          children: [
            Image.asset(
              "assets/images/offerIcon.png",
              width: screenSizeRatio * 0.04,
            ),
            Padding(
              padding: paddingSymmetric(horizontal: 0.015),
              child: Text(
                "${StringValues.offerPrice} : ",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: screenSizeRatio * 0.03),
              ),
            ),
            StreamBuilder<int>(
                stream: _bloc.offerPrice,
                builder: (context, offerPriceSnapshot) {
                  return offerPriceSnapshot.data != 0
                      ? Text(
                          "${offerPriceSnapshot.data} ₹ 🥳",
                          style: TextStyle(fontSize: screenSizeRatio * 0.04, fontWeight: FontWeight.bold),
                        )
                      : Container();
                }),
          ],
        ),
      ),
    );
  }

  showSnackBar(String message) {
    if (!context.mounted) return;

    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: MyColors.darkBlue,
          fontSize: screenSizeRatio * 0.03,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: MyColors.lightBlue,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget submitDataButton() {
    return Container(
      margin: paddingSymmetric(vertical: 0.025, horizontal: 0.04),
      width: double.maxFinite,
      height: screenSizeRatio * 0.08,
      child: commonElevatedButton(
        title: StringValues.submitData,
        bagColor: MyColors.lightBlue,
        fontColors: MyColors.darkBlue,
        onPressed: () {
          if (_bloc.validateForm()) {
            _bloc.saveData(context, itemKey: widget.itemKey);
          }
          return null;
        },
      ),
    );
  }
}
