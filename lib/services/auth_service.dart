import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifeblood_blood_donation_app/models/user_model.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');

  //user signup
  Future<void> addUser(UserModel user) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: user.email, password: user.password);
      String userId = userCredential.user?.uid??'';
      await userCollection.add({
        'userId': userId,
        'firstName': user.firstName,
        'LastName': user.lastName,
        'dob': user.dob,
        'gender': user.gender,
        'nic': user.nic,
        'licenseNumber': user.drivingLicenseNo,
        'email': user.email,
        'contactNumber': user.contactNumber,
        'addressLine1': user.addressLine1,
        'addressLine2': user.addressLine2,
        'addressLine3': user.addressLine3,
        'city': user.city,
        'province': user.province,
        'bloodType': user.bloodType,
        'healthConditions': user.healthConditions,
        'isActive': user.isActive,
        'registrationDate':Timestamp.fromDate(user.registrationDate)
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(
          "An error occurred while adding the user: $e"); 
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

  //delete account
  Future<void> deleteUser() async {
    try {
      User? user = auth.currentUser;

      if (user != null) {
        QuerySnapshot userSnapshot = await userCollection.where('userId', isEqualTo: user.uid).get();

        if(userSnapshot.docs.isNotEmpty){
          await userSnapshot.docs.first.reference.delete();
        }else{
          throw Exception('User not found..');
        }
        
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
}
