import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/services/user_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import '../../components/custom_container.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }

  Future<void> signupUser() async {
    final auth = UserService();

    setState(() {
      isLoading = true;
    });

    try {
      await auth.createUser(context,_emailController.text.trim(), _passwordController.text.trim());
      Helpers.showSucess(context, 'Signup sucessfully');
      auth.signOut();
      Navigator.pushNamed(context, '/login');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Sign Up Here',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/signup.png',
              height: 250,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomInputBox(
                  textName: 'Email',
                  hintText: 'Enter your Email',
                  controller: _emailController,
                  validator: Helpers.validateEmail,
                ),
                CustomInputBox(
                  textName: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  hasAstricks: true,
                ),
              ],
            ),
          ),

          // back to login link
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                'Back to login',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 25),

          // signup button
          CustomButton(
            onPressed: isLoading ? null : () {
              signupUser();
            },
            btnLabel: 'Sign Up',
            buttonChild: isLoading ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Colors.red,
              ),
            ) : null,
            cornerRadius: 15,
            btnColor: isLoading ? Colors.grey : Colors.white,
            btnBorderColor: Color(0xFFE50F2A),
            labelColor: isLoading ? Colors.grey :Color(0xFFE50F2A) ,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
