import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:lifeblood_blood_donation_app/services/user_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import 'package:provider/provider.dart';
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
  final UserService _userService = UserService();

  bool isLoading = false;
  String passwordStrength = '';
  
  void resetPassword(String userId) async {
    setState(() {
      isLoading = true;
    });

    if (_newPasswordController.text.isEmpty || _verifyPasswordController.text.isEmpty) {
      Helpers.showError(context, "Please fill in both the fields with your new password.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    if(_newPasswordController.text != _verifyPasswordController.text){
      Helpers.showError(context, "Passwords do not match. Please try again.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final user = await _userService.getUserById(userId);

      if (user == null) {
        Helpers.showError(context, "User not found.");
        setState(() {
          isLoading = false;
        });
        return;
      }

      if (userId.isEmpty) {
        Helpers.showError(context, "User ID is invalid.");
        setState(() {
          isLoading = false;
        });
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.uid == userId) {
        await _userService.updatePassword(_newPasswordController.text);
      } else {
        Helpers.showError(context, "You are not logged in as the current user.");
        setState(() {
          isLoading = false;
        });
        return;
      }
      
      Helpers.showSucess(context, "Password updated successfully.");
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home_profile',
        (Route<dynamic> route) => false,
      );

    } catch (e) {
      Helpers.debugPrintWithBorder("Error updating password: $e");
      Helpers.showError(context, "An error occurred. Please login again and retry.");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _verifyPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home_profile',
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        body: CustomContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Need to Change Password ?',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              
              Image.asset('assets/images/reset_pswd.png', height: 230),
              const SizedBox(height: 15),

              const Text(
                'Enter your new password below...',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
              
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomInputBox(
                      textName: 'Password',
                      hintText: 'Enter your new password',
                      controller: _newPasswordController,
                      hasAstricks: true,
                      onChanged: (value){
                        setState(() {
                          passwordStrength = Helpers.checkPasswordStrength(value);
                        });
                      },
                      validator: (value) {
                        return Helpers.validateInputFields(value, 'Please enter your password here');
                      },
                    ),
                    if (_newPasswordController.text.isNotEmpty)
                      Text(
                        'Password Strength: ${passwordStrength == 'Weak Password' ? 'Password is too weak. Try using a mix of letters, numbers, and symbols.' : passwordStrength}',
                        style: TextStyle(
                          color: passwordStrength == 'Strong Password'
                              ? Colors.green
                              : passwordStrength == 'Medium Password'
                                  ? Colors.orange
                                  : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
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
              const SizedBox(height: 20),

              CustomButton(
                onPressed: isLoading
                  ? null
                  : () => resetPassword(userProvider.user!.userId!),
                btnLabel: 'Reset Password',
                buttonChild: isLoading
                  ? const SizedBox(
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
                btnBorderColor: const Color(0xFFE50F2A),
                labelColor: isLoading ? Colors.grey : const Color(0xFFE50F2A),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
