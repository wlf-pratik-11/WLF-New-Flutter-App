import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/screens/googleMapScreen/saved_address_dl.dart';
import 'package:wlf_new_flutter_app/screens/routeOnGoogleMap/confimRouteScreen/confirm_route_screen_bloc.dart';

class ConfirmRouteScreen extends StatefulWidget {
  final SavedAddressDl origin;
  final SavedAddressDl destination;
  const ConfirmRouteScreen({super.key, required this.origin, required this.destination});

  @override
  State<ConfirmRouteScreen> createState() => _ConfirmRouteScreenState();
}

class _ConfirmRouteScreenState extends State<ConfirmRouteScreen> {
  late ConfirmRouteScreenBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = ConfirmRouteScreenBloc(context, widget.origin, widget.destination);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar("Your Trip"),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Stack(
      children: [
        // Google Map as the Background
        Positioned.fill(
          child: googleMap(),
        ),

        // Confirm Location Button Positioned at the Bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Text("Enjoy Your Trip...!!!"),
        ),
      ],
    );
  }

  Widget googleMap() {
    return StreamBuilder<Map<PolylineId, Polyline>>(
        stream: _bloc.polyLinesController,
        builder: (context, snapshot) {
          return GoogleMap(
            initialCameraPosition: CameraPosition(target: _bloc.currentLocation),
            zoomControlsEnabled: false,
            onMapCreated: _bloc.onMapCreated,
            tiltGesturesEnabled: true,
            polylines: Set<Polyline>.of(snapshot.data?.values ?? []),
            markers: Set<Marker>.of(_bloc.markers.values),
          );
        });
  }
}
