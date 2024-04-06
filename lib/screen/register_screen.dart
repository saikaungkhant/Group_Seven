import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'login_screen.dart';
import 'otp_sent.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Register Screen Demo',
      home: RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor =
        Color(0xFFB3C5C8); // Background color for the entire screen
    const Color buttonColor =
        Color(0xFF29353C); // Color for the register button
    const Color linkColor = Color(0xFF35C2C1); // Color for the "Login Now" link

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Hello! Register to get started',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              buildTextField(hint: 'Username'),
              const SizedBox(height: 15),
              buildTextField(hint: 'Email'),
              const SizedBox(height: 15),
              buildTextField(hint: 'Password', isPassword: true),
              const SizedBox(height: 15),
              buildTextField(hint: 'Confirm password', isPassword: true),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (bool? value) {
                      // Handle checkbox state change
                    },
                  ),
                  const Text('Register as a Business Owner'),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const OTPScreen())),
                child: const Text('Register', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 25),
              const Text(
                'Or Register with',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialLoginButton(assetName: 'assets/images/facebook.png'),
                  SocialLoginButton(assetName: 'assets/images/google.png'),
                  SocialLoginButton(assetName: 'assets/images/apple.png'),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: const TextStyle(fontSize: 16.0, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Login Now',
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({required String hint, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
    final double iconSize = 24;
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
