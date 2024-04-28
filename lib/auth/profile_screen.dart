import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizzeria1/auth/auth_service.dart'; // Assuming this is your Auth Service
import 'package:pizzeria1/widgets/button.dart'; // Assuming this is your custom Button widget
import 'package:pizzeria1/widgets/textfield.dart'; // Assuming this is your custom TextField widget

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isEditEnabled = false; // Flag for edit mode

  @override
  void initState() {
    super.initState();

    // Retrieve user data from Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      userRef.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          final userData = docSnapshot.data();
          final name = userData?['name'];
          final email = userData?['email'];
          final address = userData?['address'];

          // Update text field controllers with retrieved data
          _nameController.text = name ?? ''; // Handle potential null value
          _emailController.text = email ?? '';
          _addressController.text = address ?? '';
        } else {
          // Handle case where user document doesn't exist
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userRef.update({
          'name': _nameController.text,
          'email': _emailController.text,
          'address': _addressController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile Updated Successfully')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error Updating Profile: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0),

              // Profile Image Section with border and elevated shadow
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(80.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5.0,
                      blurRadius: 7.0,
                      offset: const Offset(0.0, 3.0),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 75.0,
                  backgroundImage: AssetImage(
                      'images/pizzaBackground2.png'), // You can replace with user's actual image URL
                ),
              ),
              const SizedBox(height: 40.0),
              CustomTextField(
                controller: _nameController,
                enabled: _isEditEnabled, // Editable only in edit mode
                hint: 'Enter your name',
                label: 'Name',
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: _emailController,
                enabled: _isEditEnabled,
                hint: 'Enter your email',
                label: 'Email',
              ),
              const SizedBox(height: 30),
              // Text fields
              CustomTextField(
                controller: _addressController,
                enabled: _isEditEnabled, // Editable only in edit mode
                hint: 'Enter Address',
                label: 'Address',
              ),
              const SizedBox(height: 10),

              const SizedBox(height: 30),
              // Update button (visible only in edit mode)
              Visibility(
                visible: _isEditEnabled,
                child: CustomButton(
                  label: 'Update Profile',
                  onPressed: _updateProfile,
                ),
              ),
              const SizedBox(height: 20),
              // Edit button to toggle edit mode
              ElevatedButton(
                onPressed: () =>
                    setState(() => _isEditEnabled = !_isEditEnabled),
                child: Text(_isEditEnabled ? 'Save' : 'Edit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}