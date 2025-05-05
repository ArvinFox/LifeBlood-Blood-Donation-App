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
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String passwordStrength = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signupUser() async {
    final auth = UserService();

    setState(() {
      isLoading = true;
    });

    try {
      if (_formKey.currentState!.validate() &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text) {

        await auth.createUser(context, _emailController.text.trim(), _passwordController.text.trim());
        Helpers.showSucess(context, 'Signup successfully');
        auth.signOut();
        Navigator.pushNamed(context, '/login');
      }
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomInputBox(
                      textName: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      hasAstricks: true,
                      onChanged: (value) {
                        setState(() {
                          passwordStrength = Helpers.checkPasswordStrength(value);
                        });
                      },
                      validator: (value) => (value == null || value.trim().isEmpty)
                          ? '* Required'
                          : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    if (_passwordController.text.isNotEmpty)
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
                    const SizedBox(height: 4),
                    CustomInputBox(
                      textName: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      controller: _confirmPasswordController,
                      hasAstricks: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return '* Required';
                        if (value != _passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                'Back to login',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 25),
          CustomButton(
            onPressed: isLoading ? null : () => signupUser(),
            btnLabel: 'Sign Up',
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
    );
  }
}
