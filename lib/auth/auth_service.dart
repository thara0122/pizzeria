import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class User {
  final String uid;
  final String email;
  final bool isAdmin;

  User({required this.uid, required this.email, required this.isAdmin});

  factory User.fromMap(Map<String, dynamic> map) {
    final uid = map['uid'] as String? ?? map['userId'] as String?;
    final email = map['email'] as String? ?? map['userEmail'] as String?;
    final isAdmin = map['isAdmin'] ?? false;

    if (uid == null || email == null) {
      throw Exception('Missing required fields in user data');
    }

    return User(uid: uid, email: email, isAdmin: isAdmin);
  }
}

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance; // Firestore instance

  Future<void> updateUserProfile(
      String name, String email, String imageUrl, String address) async {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    // Update user profile information
    if (user != null) {
      await user.updateProfile(displayName: name);
      await user.updateEmail(email);
      await user.updateProfile(displayName: address); // Update address field
    }

    // Update profile picture logic (if applicable)
    if (imageUrl.isNotEmpty) {
      // Update profile picture in Firebase Storage (implement your logic here)
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
      return User(
          uid: cred.user!.uid,
          email: email,
          isAdmin: false); // New user is not admin by default
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = await _getUserFromFirestore(cred.user!.uid);
      return user;
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

  Future<User?> getCurrentUser() async {
    final user = _auth.currentUser;
    return user != null ? _getUserFromFirestore(user.uid) : null;
  }

Future<User?> _getUserFromFirestore(String uid) async {
  final docRef = _firestore.collection('users').doc(uid);
  final snapshot = await docRef.get();
  if (snapshot.exists) {
    try {
      final data = snapshot.data()!;
      if (data['uid'] == null || data['email'] == null) {
        log("Firestore user data missing required fields (uid or email)");
        return null;
      }
      final isAdmin = data['isAdmin'] ?? false; // Check for isAdmin field
      return User(
        uid: data['uid'] as String,
        email: data['email'] as String,
        isAdmin: isAdmin,
      );
    } on Exception catch (e) {
      log("Error creating User object from Firestore: $e");
      return null;
    }
  }
  return null;
}

}
