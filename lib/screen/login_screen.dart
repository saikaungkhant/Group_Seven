import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color buttonColor = Color(0xFF29353C);
    const Color backgroundColor = Color(0xFFB3C5C8);
    const Color linkColor = Color(0xFF5D5FEF);
    final double fieldHeight = 50.0;
    final EdgeInsets fieldContentPadding = EdgeInsets.symmetric(
      vertical:
          (fieldHeight - 20) / 2, // Adjust the padding to center the text.
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness:
            Brightness.dark, // For dark icons on light background
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          backgroundColor: backgroundColor, // AppBar background color
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Container(
          color: backgroundColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const Text(
                    'Welcome back! Glad to see you, Again!',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),

                  const SizedBox(height: 40),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter your email',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none, // No border
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter your password',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Icon(Icons.visibility_off),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (bool? value) {
                          // Handle checkbox state change.
                        },
                      ),
                      const Text(
                        'Login as a Business Owner',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  // ... (other widgets like TextFields and the "Login as a Business Owner" checkbox) ...
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      // Implement login functionality
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20, // Custom font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Or Login with',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialLoginButton(
                          assetName: 'assets/images/facebook.png'),
                      SocialLoginButton(assetName: 'assets/images/google.png'),
                      SocialLoginButton(assetName: 'assets/images/apple.png'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.black),
                          children: <TextSpan>[
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Register Now',
                          style: const TextStyle(
                              color: linkColor, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                        )
                      ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String assetName;

  const SocialLoginButton({
    Key? key,
    required this.assetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set your desired icon size
    final double iconSize =
        24; // The desired size of the icon inside the button

    return Container(
      width: 110, // The fixed width of the button
      height: 60, // The fixed height of the button
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          // Background color
          disabledForegroundColor: Colors.black.withOpacity(0.38),
          disabledBackgroundColor: Colors.black.withOpacity(0.12),
          // Foreground color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all((60 - iconSize) / 3),
          // Centers the icon inside the button
          elevation: 0, // Removes elevation
        ),
        onPressed: () {
          // TODO: Implement social login functionality
        },
        child: Image.asset(assetName, width: iconSize, height: iconSize),
      ),
    );
  }
}
