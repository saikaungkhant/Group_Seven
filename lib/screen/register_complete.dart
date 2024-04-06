import 'package:ev/database/getdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'home_map.dart';
// Import your fetchData function

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Complete',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RegistrationCompleteScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RegistrationCompleteScreen extends StatelessWidget {
  const RegistrationCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFB3C5C8);
    const Color buttonColor = Color(0xFF29353C);

    return Scaffold(
      body: Container(
        color: backgroundColor,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Icon(
              Icons.check_circle_outline,
              size: 120.0,
              color: Colors.green,
            ),
            const SizedBox(height: 24.0),
            const Text(
              'User Registration Complete',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Please proceed to your Car Registration',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: buttonColor,
                onPrimary: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // TODO: Implement car registration logic
              },
              child: const Text(
                'Register Your Car',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30.0),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Proceed to ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: 'Roboto',
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Home Page',
                      style: TextStyle(
                        color: Colors.blue[700],
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final latLngList = await fetchData(); // Fetch data
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeMapScreen(
                                latLngList: latLngList,
                                nearestLocations: [], // Pass data to HomeMapScreen
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
