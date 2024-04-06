import 'dart:async';
import 'dart:convert';
import 'package:ev/database/nearest.dart';
import 'package:ev/database/senddata.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomeMapScreen extends StatefulWidget {
  final List<Map<String, dynamic>> latLngList;
  final List<Map<String, dynamic>> nearestLocations;
  late Future<List<Map<String, dynamic>>> nearestLocations3;

  HomeMapScreen({
    Key? key,
    required this.latLngList,
    required this.nearestLocations,
  }) : super(key: key) {
    nearestLocations3 = getNearestLocations3();
  }

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  GoogleMapController? mapController;
  static const LatLng _defaultLocation = LatLng(37.422, -122.084);
  LatLng? _currentPosition;
  bool _locationLoaded = false;
  late Timer _timer;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon1 = BitmapDescriptor.defaultMarker;
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  bool _isSearchBoxOpen = false;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredLocations = [];
  void _toggleSearchBox() {
    setState(() {
      _isSearchBoxOpen = !_isSearchBoxOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterLocations(_searchController.text);
    });

    addCustomIcon();
    addCustomnewIcon();
    _timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => _getCurrentLocation());
    sendLocationToMongoDB();
    widget.nearestLocations3.then((value) {
      setState(() {
        widget.nearestLocations.addAll(value);
      });
    });
  }

  void _filterLocations(String value) {
    setState(() {
      // Clear the filtered list
      _filteredLocations.clear();
      // Get the search query from the controller
      String query = value.toLowerCase();
      // Filter the locations based on the search query
      _filteredLocations.addAll(widget.nearestLocations.where((location) {
        return location['ChargeDeviceName'].toLowerCase().contains(query);
      }));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
    addCustomIcon();
    _searchController.dispose();
    addCustomnewIcon();
  }

  Future<List<Map<String, dynamic>>> getNearestLocations3() async {
    var connectionString =
        'mongodb+srv://sai_app_connection:sai@igpelectricalvehiclepro.2ftpj5l.mongodb.net/IgpElectricalVehicleProject?retryWrites=true&w=majority';

    List<Map<String, dynamic>> data = [];

    try {
      var db = await mongo.Db.create(connectionString);
      await db.open();

      var collection3 = db.collection('nearest_stations');

      var cursor3 = collection3.find();

      await cursor3.forEach((document) {
        var chargeDeviceName3 = document['ChargeDeviceName'];
        var chargeDeviceLocation3 = document['ChargeDeviceLocation'];

        var latitude3 =
            double.parse(chargeDeviceLocation3['Latitude'].toString());
        var longitude3 =
            double.parse(chargeDeviceLocation3['Longitude'].toString());

        data.add({
          'ChargeDeviceName': chargeDeviceName3,
          'ChargeDeviceLocation': {
            'Latitude': latitude3,
            'Longitude': longitude3,
          },
        });
      });

      await db.close();
    } catch (e) {
      print('Error connecting to MongoDB: $e');
    }

    return data;
  }

  Widget _buildSearchBox() {
    print('Nearest Locations Count: ${widget.nearestLocations.length}');

    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta! > 0) {
              // Dragging downwards
              setState(() {
                _isSearchBoxOpen = false;
              });
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _isSearchBoxOpen ? 400 : 0,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromARGB(90, 41, 53, 60),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: _filterLocations,
                  ),
                  SizedBox(height: 16), // Add space between search box and list
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredLocations.isEmpty
                          ? widget.nearestLocations.length
                          : _filteredLocations.length,
                      itemBuilder: (context, index) {
                        var station = _filteredLocations.isEmpty
                            ? widget.nearestLocations[index]
                            : _filteredLocations[index];
                        var name = station['ChargeDeviceName'];
                        var location = station['ChargeDeviceLocation'];
                        var latitude = location['Latitude'];
                        var longitude = location['Longitude'];
                        return GestureDetector(
                          onTap: () {
                            _getRouteFromCurrentLocation(latitude, longitude);
                            _isSearchBoxOpen = false;
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              title: Text(
                                name,
                                style: TextStyle(
                                    color: Color(0xFF29353C),
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Latitude: $latitude, Longitude: $longitude',
                                style: TextStyle(color: Color(0xFF29353C)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: _toggleSearchBox,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 03, horizontal: 56),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _moveCameraToLocation(double latitude, double longitude) {
    if (mapController != null) {
      mapController!
          .animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
    }
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/car_location.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  void addCustomnewIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/station.png")
        .then(
      (icon) {
        setState(() {
          markerIcon1 = icon;
        });
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _locationLoaded = true;
      });
    } catch (e) {
      print('Error getting current location: $e');
      setState(() {
        _currentPosition = _defaultLocation;
        _locationLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('LatLngList: ${widget.latLngList}');
    return GestureDetector(
      onTap: () {
        _isSearchBoxOpen = false;
      },
      child: _locationLoaded
          ? Stack(
              children: [
                _buildMap(),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: FloatingActionButton(
                    onPressed: _toggleSearchBox,
                    child: Icon(Icons.search),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: _buildSearchBox(),
                ),
              ],
            )
          : Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  Widget _buildMap() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSearchBoxOpen = false;
        });
      },
      child: Scaffold(
        body: GoogleMap(
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
          markers: _createMarkers(),
          polylines: _polylines,
          initialCameraPosition: CameraPosition(
            target: _currentPosition ?? _defaultLocation,
            zoom: 15.0,
          ),
        ),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    print('Creating markers...');
    Set<Marker> markers = Set<Marker>.from(
      widget.latLngList.map((latLng) {
        final latitude = latLng['latitude'] as double;
        final longitude = latLng['longitude'] as double;
        final title = latLng['title'] != null
            ? latLng['title'] as String
            : 'Unknown Title'; // Provide a default value if title is null

        final markerId = MarkerId('$latitude-$longitude');

        print('Marker created: $latitude, $longitude');

        return Marker(
          markerId: markerId,
          position: LatLng(latitude, longitude),
          icon: markerIcon1,
          infoWindow: InfoWindow(
            title: title,
            snippet: 'Latitude: $latitude, Longitude: $longitude',
          ),
          onTap: () {
            _getDirections(_currentPosition!.latitude,
                _currentPosition!.longitude, latitude, longitude);
          },
        );
      }),
    );

    if (_currentPosition != null) {
      // Add marker for current position with car icon
      markers.add(
        Marker(
          markerId: MarkerId('currentPosition'),
          position: _currentPosition!,
          icon: markerIcon,
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
      );
    }

    return markers;
  }

  Future<void> _getRouteFromCurrentLocation(
      double endLat, double endLng) async {
    // Get the current location
    double startLat = _currentPosition!.latitude;
    double startLng = _currentPosition!.longitude;

    // Construct the URL for the directions API
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=AIzaSyAnPQVhyNPd-89TUmpAhROolEkJffhhiUo';

    // Make the HTTP request to get the route data
    http.Response response = await http.get(Uri.parse(url));

    // Decode the response JSON
    Map values = jsonDecode(response.body);

    // Extract the route information
    List<dynamic> routes = values['routes'];
    Map<String, dynamic> route = routes[0];
    Map<String, dynamic> poly = route['overview_polyline'];
    List<dynamic> steps = route['legs'][0]['steps'];

    // Update the state to redraw the route on the map
    setState(() {
      _polylineCoordinates.clear();
      _polylines.clear();

      _polylines.add(Polyline(
        polylineId: PolylineId('route1'),
        width: 5,
        points: _convertToLatLng(_decodePoly(poly['points'])),
        color: Colors.blue,
      ));

      for (int i = 0; i < steps.length; i++) {
        double startLat = steps[i]['start_location']['lat'];
        double startLng = steps[i]['start_location']['lng'];
        double endLat = steps[i]['end_location']['lat'];
        double endLng = steps[i]['end_location']['lng'];
        _polylineCoordinates.add(LatLng(startLat, startLng));
        _polylineCoordinates.add(LatLng(endLat, endLng));
      }

      // Move camera to fit the bounds of the route
      _moveCameraToBounds(_polylineCoordinates);
    });
  }

  Future<void> _getDirections(
      double startLat, double startLng, double endLat, double endLng) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=AIzaSyAnPQVhyNPd-89TUmpAhROolEkJffhhiUo';

    http.Response response = await http.get(Uri.parse(url));
    Map values = jsonDecode(response.body);
    List<dynamic> routes = values['routes'];
    Map<String, dynamic> route = routes[0];
    Map<String, dynamic> poly = route['overview_polyline'];
    List<dynamic> steps = route['legs'][0]['steps'];

    setState(() {
      _polylineCoordinates.clear();
      _polylines.clear();

      _polylines.add(Polyline(
        polylineId: PolylineId('route1'),
        width: 5,
        points: _convertToLatLng(_decodePoly(poly['points'])),
        color: Colors.blue,
      ));

      for (int i = 0; i < steps.length; i++) {
        double startLat = steps[i]['start_location']['lat'];
        double startLng = steps[i]['start_location']['lng'];
        double endLat = steps[i]['end_location']['lat'];
        double endLng = steps[i]['end_location']['lng'];
        _polylineCoordinates.add(LatLng(startLat, startLng));
        _polylineCoordinates.add(LatLng(endLat, endLng));
      }

      // Move camera to fit the bounds of the route
      _moveCameraToBounds(_polylineCoordinates);
    });
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = [];
    for (int i = 0; i < points.length; i += 2) {
      result.add(LatLng(points[i], points[i + 1]));
    }
    return result;
  }

  List _decodePoly(String encoded) {
    List poly = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      poly.add(latitude);
      poly.add(longitude);
    }
    return poly;
  }

  void _moveCameraToBounds(List<LatLng> polylineCoordinates) {
    if (polylineCoordinates.isEmpty) return;

    double minLat = polylineCoordinates[0].latitude;
    double maxLat = polylineCoordinates[0].latitude;
    double minLng = polylineCoordinates[0].longitude;
    double maxLng = polylineCoordinates[0].longitude;

    for (LatLng point in polylineCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    mapController!.animateCamera(cameraUpdate);
  }
}
