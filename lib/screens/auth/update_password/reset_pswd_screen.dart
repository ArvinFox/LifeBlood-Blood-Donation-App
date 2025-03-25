import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/services/user_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import '../../../components/custom_container.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String contactNumber;

  const ResetPasswordScreen(
      {super.key, required this.contactNumber});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _verifyPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  
  void resetPassword() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final authService = UserService();
    Helpers helper = Helpers();

    setState(() {
      isLoading = true;
    });

    if(_newPasswordController.text != _verifyPasswordController.text){
      Helpers.showError(context, "Passwords do not match. Please try again.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try{
      final user = await firestore.collection('user').where('personalInfo.contactNumber',isEqualTo: widget.contactNumber).get();

      if(user.docs.isEmpty){
        Helpers.showError(context, "User not found.");
        setState(() {
          isLoading = false;
        });
        return;
      }

      DocumentSnapshot userDoc = user.docs.first;
      String userId = userDoc['personalInfo']['userId'];

      if (userId == null || userId.isEmpty) {
        Helpers.showError(context, "User ID is invalid.");
        setState(() {
          isLoading = false;
        });
        return;
      }

      User? currentUser = auth.currentUser;
      if(currentUser != null && currentUser.uid == userId){
        await authService.updatePassword(_newPasswordController.text);
      }
      else{
        Helpers.showError(context, "You are not logged in as the current user.");
        setState(() {
          isLoading = false;
        });
        return;
      }
      
      String hashedPassword = helper.hashPassword(_newPasswordController.text);
      await firestore.collection('user').doc(userId).update({
        'personalInfo.password': hashedPassword,
      });

      Helpers.showSucess(context, "Password reset successfully.");
      authService.signOut(); //for logout user
      Navigator.pushNamed(context, '/login');

    }catch (e){
      Helpers.showError(context, "An error occurred. Please try again.");
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _newPasswordController.dispose();
    _verifyPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 20),
            Text(
              'Need to Change Password ?',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Image.asset('assets/images/reset_pswd.png', height: 230),
            SizedBox(height: 15),
            Text(
              'Enter your new password below...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 15),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomInputBox(
                    textName: 'Password',
                    hintText: 'Enter your new password',
                    controller: _newPasswordController,
                    hasAstricks: true,
                    validator: (value) {
                      return Helpers.validateInputFields(value, 'Please enter your password here');
                    },
                  ),
                  CustomInputBox(
                    textName: 'Verify Password',
                    hintText: 'Re-enter your new password',
                    controller: _verifyPasswordController,
                    hasAstricks: true,
                    validator: (value) {
                      return Helpers.validateInputFields(value, 'Please re-enter your password here');
                    }
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              onPressed: isLoading
                ? null
                : () {
                  resetPassword();
                },
              btnLabel: 'Reset Password',
              buttonChild: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.red,
                    ),
                  )
                : null,
              cornerRadius: 15,
              btnColor: isLoading ? Colors.grey : Colors.white,
              btnBorderColor: Color(0xFFE50F2A),
              labelColor: isLoading ? Colors.grey : Color(0xFFE50F2A),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
