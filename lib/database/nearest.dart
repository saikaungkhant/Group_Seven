import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class NearestLocationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearest Stations'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getNearestLocations3(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> nearestLocations = snapshot.data!;
            return ListView.builder(
              itemCount: nearestLocations.length,
              itemBuilder: (context, index) {
                var station = nearestLocations[index];
                var name = station['ChargeDeviceName'];
                var location = station['ChargeDeviceLocation'];
                var latitude = location['Latitude'];
                var longitude = location['Longitude'];
                return ListTile(
                  title: Text(name),
                  subtitle: Text('Latitude: $latitude, Longitude: $longitude'),
                );
              },
            );
          }
        },
      ),
    );
  }
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
    // Handle the error appropriately, such as displaying an error message.
  }

  return data;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: NearestLocationsList()));
}
