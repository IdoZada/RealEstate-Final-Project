import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_estate/Business_Logic/Property/property.dart';

class GoogleMapScreen extends StatefulWidget {
  final List<Property> properties;
  final BitmapDescriptor myIcon;
  GoogleMapScreen(this.properties, this.myIcon);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          _googlemap(context),
        ],
      ),
    );
  }

  Widget _googlemap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: LatLng(
              this.widget.properties[0].latitude,
              this.widget.properties[0].longitude,
            ),
            zoom: 16),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markersPositionsPropertiesOnMap(),
      ),
    );
  }

  Set<Marker> markersPositionsPropertiesOnMap() {
    Set<Marker> setMarkers = {};
    for (var i = 0; i < this.widget.properties.length; i++) {
      setMarkers.add(Marker(
        markerId: MarkerId(this.widget.properties[i].userId),
        position: LatLng(
          this.widget.properties[i].latitude,
          this.widget.properties[i].longitude,
        ),
        infoWindow: InfoWindow(title: this.widget.properties[i].name),
        icon: this.widget.myIcon,
      ));
    }
    return setMarkers;
  }
}
