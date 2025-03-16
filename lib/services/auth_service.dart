import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifeblood_blood_donation_app/models/user_model.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');

  //user signup
  Future<void> addUser(UserModel user) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: user.personalInfo.email, password: user.personalInfo.password);

      //get the user id from firebase auth
      String uId = userCredential.user?.uid??'';
      user.personalInfo.userId = uId;

      await userCollection.doc(uId).set(user.toFirestore());

    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception("An error occurred while adding the user: $e"); 
    }
  }

  //user login
  Future<UserCredential> signInWithEmailAndPassword(String email, password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
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
        await userCollection.doc(user.uid).delete();
        await user.delete();
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
    try{
      User? user = auth.currentUser;

      if(user != null){
        await user.updatePassword(newPassword);
      }else{
        throw Exception('No user is currently logged in.');
      }
    }on FirebaseAuthException catch (e){
      throw Exception('Failed to update password : ${e.message}');
    }catch (e){
      throw Exception('An error occurred while updating the password : $e');
    }
  }
}
