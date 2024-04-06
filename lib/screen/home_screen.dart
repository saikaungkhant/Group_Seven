import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'login_screen.dart'; // Import the LoginScreen
import 'register_screen.dart'; // Import the RegisterScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required LatLng currentPosition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color buttonColor = Color(0xFF29353C);
    const Color text1Color = Color(0xFF5D5FEF);
    const Color text2Color = Color(0xFF35C2C1);

    final double logoWidthRatio = 60;
    final double logoHeightRatio = 10;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height *
                    0.04, // Adjust the space from the bottom as needed
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: logoWidthRatio / logoHeightRatio,
                    child: Image.asset(
                      'assets/images/logo_banner.png', // Replace with your actual logo asset
                    ),
                  ),
                  const SizedBox(height: 0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.8, 50),
                    ).copyWith(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return buttonColor.withOpacity(0.1);
                          return null;
                        },
                      ),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen())),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20, // Custom font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Space between buttons
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.8, 50),
                    ).copyWith(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return buttonColor.withOpacity(0.1);
                          return null;
                        },
                      ),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen())),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20, // Custom font size
                        fontWeight: FontWeight.bold, // Custom font weight
                        // You can add more styles like font family, letter spacing, etc.
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Add logic for continue as guest
                    },
                    child: const Text('Continue as a guest',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
