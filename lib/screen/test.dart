import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MaterialApp(
    home: CustomIconMapScreen(),
  ));
}

class CustomIconMapScreen extends StatefulWidget {
  @override
  _CustomIconMapScreenState createState() => _CustomIconMapScreenState();
}

class _CustomIconMapScreenState extends State<CustomIconMapScreen> {
  late GoogleMapController mapController;
  BitmapDescriptor? customIcon;
  static const LatLng _center =
      const LatLng(37.7749, -122.4194); // San Francisco, CA

  @override
  void initState() {
    super.initState();
    _loadCustomIcon();
  }

  void _loadCustomIcon() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(100, 80)),
      'assets/images/station.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Icon Map'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 12.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('customIconMarker'),
            position: _center,
            icon: customIcon ?? BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: 'Custom Icon Marker',
              snippet: 'This is a custom icon marker',
            ),
          ),
        },
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
