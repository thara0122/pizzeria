import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<void> updateUserProfile(
      String name, String email, String imageUrl, String address) async {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    // Update user profile information
    if (user != null) {
      await user.updateProfile(displayName: name);
      await user.updateEmail(email);
      await user.updateProfile(displayName: address);

      // Update profile picture logic (if applicable)
      if (imageUrl.isNotEmpty) {
        // Update profile picture in Firebase Storage (implement your logic here)
      }
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      log("Password reset link sent to: $email");
    } catch (e) {
      log("Error sending password reset link: $e");
      // Handle error (optional)
    }
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Something went wrong");
    }
  }
}
