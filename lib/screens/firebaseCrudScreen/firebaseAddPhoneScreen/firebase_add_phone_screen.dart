import 'package:flutter/material.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';

class FirebaseAddPhoneScreen extends StatefulWidget {
  const FirebaseAddPhoneScreen({super.key});

  @override
  State<FirebaseAddPhoneScreen> createState() => _FirebaseAddPhoneScreenState();
}

class _FirebaseAddPhoneScreenState extends State<FirebaseAddPhoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(StringValues.addPhoneDetails),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Column(
      children: [
        inputField("Phone Name", TextEditingController()),
        inputField("Phone Name", TextEditingController()),
        inputField("Phone Name", TextEditingController()),
        inputField("Phone Name", TextEditingController()),
        inputField("Phone Name", TextEditingController()),
        inputField("Phone Name", TextEditingController()),
      ],
    );
  }
}
