import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/user_model.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';

class UserService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollection =  FirebaseFirestore.instance.collection('user');

  //user signup
  Future<void> createUser(BuildContext context,String email, password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if(user != null){
        await userCollection.doc(user.uid).set({
          'email': user.email,
          'createdAt': DateTime.now(),
          'isDonorPromptShown': false,
          'isDonorVerified': false,
          'hasCompletedProfile': false,
        });
      }
      
    } on FirebaseAuthException catch (e){
      if(e.code == 'email-already-in-use'){
        Helpers.showError(context, "Email is already registered. Please try a different email or login.");
      } else {
        Helpers.showError(context, "Signup failed.");
      }
      throw Exception(e);
    } catch (e) {
      throw Exception("An error occurred while adding the user: $e");
    }
  }

  //user login
  Future<UserCredential> signInWithEmailAndPassword(String email, password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //logout
  Future<void> signOut() async {
    return await auth.signOut();
  }

  //delete user
  Future<void> deleteUser() async {
    try {
      User? user = auth.currentUser;

      if (user != null) {
        await user.delete();
        await userCollection.doc(user.uid).delete();
      } else {
        throw Exception('No user is currently logged in..');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to delete user : ${e.message}');
    } catch (e) {
      throw Exception('An error occured : $e');
    }
  }

  //update current user password
  Future<void> updatePassword(String newPassword) async {
    try {
      User? user = auth.currentUser;

      if (user != null) {
        await user.updatePassword(newPassword);
      } else {
        throw Exception('No user is currently logged in.');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to update password : ${e.message}');
    } catch (e) {
      throw Exception('An error occurred while updating the password : $e');
    }
  }

  // Get a user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot userDoc = await userCollection.doc(userId).get();
      if (!userDoc.exists) return null;

      return UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>, userId);
    } catch (e) {
      throw Exception("Failed to fetch user: $e");
    }
  }

  // Get all users
  Future<List<UserModel?>> getAllUsers() async {
    try {
      QuerySnapshot userDocs = await userCollection.get();
      return userDocs.docs.map((doc) {
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch all users: $e");
    }
  }

  // Update status
  Future<void> updateStatus(String userId, String property, bool value) async {
    try {
      await userCollection.doc(userId).update({property: value});
    } catch (e) {
      throw Exception("Failed to update status [$property]: $e");
    }
  }

  //get donor status
  Stream<bool> getDonorStatus(String userId) {
    return userCollection.doc(userId).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      return data?['isDonorVerified'] ?? false;
    });
  }

  //update user availability status
  Future<void> updateAvailabilityStatus(String userId, bool isActive) async{
    try{
      await userCollection.doc(userId).update({
        'isActive': isActive
      });
    } catch (e){
      throw Exception("Failed to update user: $e");
    }
  }

  // check user email in user collection
  Future<bool> doesUserExist(String email) async {
    try {
      final querySnapshot = await userCollection.where('email', isEqualTo: email).limit(1).get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }
}
