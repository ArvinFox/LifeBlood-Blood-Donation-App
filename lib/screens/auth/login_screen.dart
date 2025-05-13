import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/services/user_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import '../../components/custom_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  void loginUser() async {
    final auth = UserService();

    setState(() {
      isLoading = true;
    });

    try {
      if(_formKey.currentState!.validate() && _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
        await auth.signInWithEmailAndPassword(_emailController.text.trim(), _passwordController.text.trim());
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      Helpers.showError(context, "Login failed. Please try again using correct credentials.");
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
              'Welcome Back',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          Center(
            child: Image.asset(
              'assets/images/login.png',
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                
                CustomInputBox(
                  textName: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  hasAstricks: true,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? '* Required'
                      : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ],
            ),
          ),

          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/forgot-password');
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 25),

          // Login button
          CustomButton(
            onPressed: isLoading ? null : () {
              loginUser();
            },
            btnLabel: 'Login',
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
            btnBorderColor: Color(0xFFE50F2A),
            labelColor: isLoading ? Colors.grey :Color(0xFFE50F2A) ,
          ),
          const SizedBox(height: 18),

          // Signup Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(
                  color: Color(0xFF616161),
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
