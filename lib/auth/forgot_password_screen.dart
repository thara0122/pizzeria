import 'package:flutter/material.dart';
import 'package:pizzeria1/auth/auth_service.dart';
import 'package:pizzeria1/widgets/button.dart';
import 'package:pizzeria1/widgets/textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Stack(
        // Use a Stack widget for layering
        children: [
          // Background image container
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/PizzaBackground5.jpeg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content of the forgot password screen
          Center(
            // Center content vertically within the Stack
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    hint: "Enter Registered Email",
                    label: "Email",
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    label: "Send Reset Link",
                    onPressed: () async {
                      await AuthService()
                          .sendPasswordResetEmail(_emailController.text);
                      // Show success message
                    },
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
