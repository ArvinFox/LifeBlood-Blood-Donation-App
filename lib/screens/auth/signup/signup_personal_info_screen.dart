import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import '../../../components/custom_container.dart';
import '../../../components/login_button.dart';

class SignupPersonalInfoScreen extends StatefulWidget {
  final String screenTitle;

  const SignupPersonalInfoScreen({
    super.key,
    required this.screenTitle,
  });

  @override
  State<SignupPersonalInfoScreen> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<SignupPersonalInfoScreen> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String selectedGender = "Male";

  final _formKey = GlobalKey<FormState>();

  //validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email here';
    }
    const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (!RegExp(emailRegex).hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  void signupUser(context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      if (_passwordController.text == _confirmPasswordController.text) {
        //navigate to the next page
        Navigator.pushReplacementNamed(
          context,
          '/signup-address-info',
          arguments: widget.screenTitle,
        );
      } else {
        //display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Passwords are doesn't match",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black.withOpacity(0.3),
          ),
        );
      }
    } else {
      //display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black.withOpacity(0.3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                  widget.screenTitle == 'profilePage' ? '' : 'Sign Up Here',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                  widget.screenTitle == 'profilePage'
                      ? 'Edit Personal Information'
                      : 'Personal Information',
                  style: TextStyle(
                      fontSize: 18,
                      color: const Color(0xFFE50F2A),
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: 15),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInputBox(
                    textName: 'First Name',
                    hintText: 'Enter your first name',
                    controller: _fnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name here';
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomInputBox(
                    textName: 'Last Name',
                    hintText: 'Enter your last name',
                    controller: _lnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name here';
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomInputBox(
                    textName: 'Date of Birth',
                    hintText: 'Enter your date of birth',
                    controller: _dobController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your dob here';
                      } else {
                        return null;
                      }
                    },
                  ),
                  Text(
                    "Gender",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  DropdownButtonFormField(
                    value: selectedGender,
                    items: ["Male", "Female"]
                        .map((item) =>
                            DropdownMenuItem(value: item, child: Text(item)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedGender = value.toString());
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomInputBox(
                    textName: 'NIC',
                    hintText: 'Enter your NIC number',
                    controller: _nicController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your NIC here';
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomInputBox(
                    textName: 'Driving License Number (opt)',
                    hintText: 'Enter your license number',
                    controller: _licenseController,
                  ),
                  CustomInputBox(
                    textName: 'Email',
                    hintText: 'Enter your Email',
                    controller: _emailController,
                    validator: validateEmail,
                  ),
                  CustomInputBox(
                    textName: 'Contact Number',
                    hintText: 'Enter Contact Number',
                    controller: _contactController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter your contact number';
                      } else if (value.length != 10) {
                        return 'Contact number length should 10';
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomInputBox(
                    textName: 'Password',
                    hintText: 'Enter your password',
                    controller: _passwordController,
                    hasAstricks: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password here';
                      } else if (value.length < 5) {
                        return 'Your password should have more than 5 characters.';
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomInputBox(
                    textName: 'Confirm Password',
                    hintText: 'Enter your password again',
                    controller: _confirmPasswordController,
                    hasAstricks: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password here';
                      } else if (value.length < 5) {
                        return 'Your password should have more than 5 characters.';
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 120,
                  child: LoginButton(
                    text: "Back",
                    onPressed: () {
                      widget.screenTitle == 'profilePage'
                          ? Navigator.popAndPushNamed(context, '/profile')
                          : Navigator.popAndPushNamed(context, '/login');
                    },
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: LoginButton(
                    text: "Next",
                    onPressed: () {
                      signupUser(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
