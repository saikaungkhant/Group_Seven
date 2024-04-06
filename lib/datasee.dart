import 'package:mongo_dart/mongo_dart.dart';

Future<void> main() async {
  var connectionString =
      'mongodb+srv://sai_app_connection:sai@igpelectricalvehiclepro.2ftpj5l.mongodb.net/IgpElectricalVehicleProject?retryWrites=true&w=majority';

  try {
    var db = await Db.create(connectionString);
    await db.open();

    var collection = db.collection('nearest_stations');

    var cursor = await collection.find().toList();

    print('Data in the "nearest_stations" collection:');
    for (var document in cursor) {
      print(document);
    }

    await db.close();
  } catch (e) {
    print('Error connecting to MongoDB: $e');
  }
}
