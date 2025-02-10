import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/googleMapScreen/google_map_screen_bloc.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapScreenBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = GoogleMapScreenBloc();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(StringValues.googleMap),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.lightBlue,
        onPressed: () {
          _bloc.getCurrentLocation();
        },
        child: Icon(
          Icons.my_location_outlined,
          color: MyColors.darkBlue,
        ),
      ),
    );
  }

  _buildBody() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GoogleMap(
          initialCameraPosition: _bloc.kGooglePlex,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _bloc.mapController.complete(controller);
          },
        ),
      ],
    );
  }
}
