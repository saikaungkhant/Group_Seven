import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'register_complete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Verification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const OTPScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OTPScreen extends StatelessWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFB3C5C8);
    const Color buttonColor = Color(0xFF29353C);
    const Color linkColor =
        Color(0xFF35C2C1); // Background color for the screen

    return Scaffold(
      backgroundColor:
          backgroundColor, // Set the background color of the Scaffold
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: backgroundColor, // Set the AppBar background color
        elevation: 0, // Removes the shadow from the app bar.
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          // Padding for the entire screen
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16), // Space from top
              const Text(
                'Enter the verification code we just sent on your email address.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24), // Space between text and OTP fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => _buildOTPBox(context)),
              ),
              const SizedBox(
                  height: 24), // Space between OTP fields and verify button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: buttonColor, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Add your OTP verification logic here
                  // If verification is successful, navigate to the RegistrationCompleteScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const RegistrationCompleteScreen()),
                  );
                },
                child: const Text(
                  'Verify',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                  height: 24), // Space between verify button and resend link
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Didn't receive code? ",
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'Resend',
                        style: const TextStyle(
                          color: linkColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24), // Space at the bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPBox(BuildContext context) {
    return Container(
      width: 55, // Width of the OTP box
      height: 55, // Height of the OTP box
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the text field
        borderRadius:
            BorderRadius.circular(12), // Border radius of the text field
      ),
      child: Center(
        child: TextField(
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
          decoration: const InputDecoration(
            border: InputBorder.none, // No border
            counterText: "", // Hide the counter text below the TextField
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
        ),
      ),
    );
  }
}
