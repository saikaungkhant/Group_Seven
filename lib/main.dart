import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ev/screen/home_screen.dart'; // Import your HomeScreen widget here

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationPermissionPage(),
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}

class LocationPermissionPage extends StatefulWidget {
  @override
  _LocationPermissionPageState createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> {
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Location permission is granted, navigate to HomeScreen and pass the current location
      var currentPosition = await _getCurrentLocation();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(currentPosition: currentPosition)),
      );
    } else if (status.isDenied) {
      // Location permission is denied, show a message to the user
      // You may want to handle this case by requesting permission again or informing the user about the importance of location access
    } else if (status.isPermanentlyDenied) {
      // Location permission is permanently denied, show an error message and redirect the user to app settings
      // You may want to inform the user about the importance of location access and guide them to app settings to enable it
    }
  }

  Future<LatLng> _getCurrentLocation() async {
    try {
      var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting current location: $e');
      return LatLng(
          0, 0); // Default to (0, 0) if unable to get current location
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can display a loading indicator or any other UI while requesting permissions
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
