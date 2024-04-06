import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:geolocator/geolocator.dart';

Future<void> sendLocationToMongoDB() async {
  var connectionString =
      'mongodb+srv://sai_app_connection:sai@igpelectricalvehiclepro.2ftpj5l.mongodb.net/IgpElectricalVehicleProject?retryWrites=true&w=majority';

  try {
    var db = await Db.create(connectionString);
    await db.open();

    var collection = db.collection('CurrentLocation');

    Timer.periodic(Duration(seconds: 5), (Timer t) async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        var document = {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': DateTime.now(),
        };

        await collection.insert(document);
        print('Location data sent to MongoDB: $document');
      } catch (e) {
        print('Error getting current location: $e');
      }
    });
  } catch (e) {
    print('Error connecting to MongoDB: $e');
  }
}

void main() {
  sendLocationToMongoDB();
}
