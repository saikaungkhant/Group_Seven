import 'package:mongo_dart/mongo_dart.dart';

Future<List<Map<String, dynamic>>> fetchData() async {
  var connectionString =
      'mongodb+srv://sai_app_connection:sai@igpelectricalvehiclepro.2ftpj5l.mongodb.net/IgpElectricalVehicleProject?retryWrites=true&w=majority';

  List<Map<String, dynamic>> data = [];

  try {
    var db = await Db.create(connectionString);
    await db.open();

    var collection = db.collection('Stations');

    var cursor = collection.find();

    await cursor.forEach((document) {
      var chargeDeviceName = document['ChargeDeviceName'];
      var chargeDeviceLocation = document['ChargeDeviceLocation'];
      var latitude = double.parse(chargeDeviceLocation['Latitude']
          .toString()); // Parse latitude as double
      var longitude = double.parse(chargeDeviceLocation['Longitude']
          .toString()); // Parse longitude as double
      var title =
          document['ChargeDeviceName']; // Get the title from the document

      data.add({
        'ChargeDeviceName': chargeDeviceName,
        'latitude': latitude,
        'longitude': longitude,
        'title': title, // Add the title to the data
      });
    });

    await db.close();
  } catch (e) {
    print('Error connecting to MongoDB: $e');
  }

  return data;
}
