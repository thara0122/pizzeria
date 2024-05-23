import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizzeria1/auth/auth_service.dart';
import 'package:pizzeria1/widgets/button.dart';
import 'package:pizzeria1/widgets/textfield.dart';

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
  final _userImage = AssetImage('images/pizzaBackground2.png');

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
          _nameController.text = name ?? '';
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

  void _deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Delete user from Firebase Authentication
        await user.delete();

        // Delete user document from Firestore
        final userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userRef.delete();

        // Navigate back to login screen
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error Deleting Account: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.redAccent,
                      width: 3.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 75.0,
                    backgroundImage: _userImage,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {
                        // Add functionality to change profile picture
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            CustomTextField(
              controller: _nameController,
              enabled: _isEditEnabled, // Editable only in edit mode
              hint: 'Enter your name',
              label: 'Name',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _emailController,
              enabled: _isEditEnabled,
              hint: 'Enter your email',
              label: 'Email',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _addressController,
              enabled: _isEditEnabled, // Editable only in edit mode
              hint: 'Enter Address',
              label: 'Address',
            ),
            const SizedBox(height: 30),
            if (_isEditEnabled)
              CustomButton(
                label: 'Update Profile',
                onPressed: _updateProfile,
              ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => showDialog<void>(
                context: context,
                barrierDismissible:
                    false, // Prevent user from closing dialog without action
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Delete Account'),
                  content: const Text(
                    'Are you sure you want to delete your account? This action is irreversible.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _deleteAccount();
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              child: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              onPressed: () => setState(() => _isEditEnabled = !_isEditEnabled),
              child: Text(_isEditEnabled ? 'Save' : 'Edit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
