import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pizzeria1/auth/auth_service.dart';
import 'package:pizzeria1/auth/forgot_password_screen.dart';
import 'package:pizzeria1/auth/signup_screen.dart';
import 'package:pizzeria1/home_screen.dart';
import 'package:pizzeria1/test.dart';
import 'package:pizzeria1/widgets/button.dart';
import 'package:pizzeria1/widgets/textfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();

  final _email = TextEditingController();
  final _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image container
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/test.jpeg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content of the login screen
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Spacer(),
                  const Text("Login", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 50),
                  CustomTextField(
                    hint: "Enter Email",
                    label: "Email",
                    controller: _email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hint: "Enter Password",
                    label: "Password",
                    controller: _password,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    label: "Login",
                    onPressed: _login,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Forgot Password? "),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        ),
                        child: const Text("Reset"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      InkWell(
                        onTap: () => goToSignup(context),
                        child: const Text("Signup", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

  goToAdminHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage()),
      );

  // Subscribe the user to their unique topic for order status updates
  void subscribeToOrderStatusTopic(String userId) {
    FirebaseMessaging.instance.subscribeToTopic('order_status_$userId');
  }

  _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);

      if (user != null) {
        log("User Logged In");

        // Subscribe to order status notifications
        subscribeToOrderStatusTopic(user.uid); // Assuming `user.id` is the userId

        if (user.isAdmin) {
          goToAdminHome(context);
        } else {
          goToHome(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please check your credentials and try again.'),
          ),
        );
      }
    }
  }
}
