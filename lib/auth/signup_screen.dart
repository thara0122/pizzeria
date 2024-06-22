import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizzeria1/auth/auth_service.dart';
import 'package:pizzeria1/auth/login_screen.dart';
import 'package:pizzeria1/home_screen.dart';
import 'package:pizzeria1/widgets/button.dart';
import 'package:pizzeria1/widgets/textfield.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _address = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _address.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // Use a Stack widget for layering
        children: [
          // Background image container
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/test.jpeg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content of the signup screen
          Center(
            // Center content vertically within the Stack
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Spacer(),
                    const Text(
                      "Signup",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomTextField(
                      hint: "Enter Name",
                      label: "Name",
                      controller: _name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hint: "Enter Email",
                      label: "Email",
                      controller: _email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hint: "Enter Password",
                      label: "Password",
                      isPassword: true,
                      controller: _password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hint: "Enter Address",
                      label: "Address",
                      controller: _address,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      label: "Signup",
                      onPressed: _signup,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        InkWell(
                          onTap: () => goToLogin(context),
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

  _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = await _auth.createUserWithEmailAndPassword(
          _email.text, _password.text);
      if (user != null) {
        log("User Created Successfully");

        // Save user data in Firestore
        final userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userRef.set({
          'name': _name.text,
          'email': user.email,
          'address': _address.text,
          'isAdmin': false,
        });

        goToHome(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signup failed. Please try again.'),
          ),
        );
      }
    }
  }
}
