import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import '../../components/custom_container.dart';
import '../../components/login_button.dart';

class SignupAddressInfoScreen extends StatefulWidget {
  final String screenTitle;

  const SignupAddressInfoScreen({
    super.key,
    required this.screenTitle,
  });

  @override
  State<SignupAddressInfoScreen> createState() => _AddressInfoPageState();
}

class _AddressInfoPageState extends State<SignupAddressInfoScreen> {
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _addressLine3Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  String selectedProvince = "Central Province";

  final _formKey = GlobalKey<FormState>();

  void signupUserMedicalInfo(context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      //navigate to the next page
      Navigator.pushReplacementNamed(context, '/signup-medical-info',
          arguments: widget.screenTitle);
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          Center(
            child: Text(
                widget.screenTitle == 'profilePage'
                    ? 'Edit Address Information'
                    : 'Address Information',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFE50F2A),
                    fontWeight: FontWeight.w500)),
          ),
          SizedBox(height: 25),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInputBox(
                  textName: 'Address Line 1',
                  hintText: 'Enter your address',
                  controller: _addressLine1Controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address here';
                    } else {
                      return null;
                    }
                  },
                ),
                CustomInputBox(
                  textName: 'Address Line 2',
                  hintText: 'Enter your address',
                  controller: _addressLine2Controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address here';
                    } else {
                      return null;
                    }
                  },
                ),
                CustomInputBox(
                  textName: 'Address Line 3',
                  hintText: 'Enter your address',
                  controller: _addressLine3Controller,
                ),
                CustomInputBox(
                  textName: 'City',
                  hintText: 'Enter your city',
                  controller: _cityController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city here';
                    } else {
                      return null;
                    }
                  },
                ),
                Text(
                  "Province",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                DropdownButtonFormField(
                  value: selectedProvince,
                  items: [
                    "Central Province",
                    "Eastern Province",
                    "Northern Province",
                    "North Central Province",
                    "North Western Province",
                    "Sabaragamuwa Province",
                    "Southern Province",
                    "Uva Province",
                    "Western Province"
                  ]
                      .map((item) =>
                          DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedProvince = value.toString());
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 45),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 120,
                child: LoginButton(
                  text: "Back",
                  onPressed: () {
                    widget.screenTitle == 'profilePage'
                        ? Navigator.popAndPushNamed(
                            context, '/signup-personal-info',
                            arguments: widget.screenTitle)
                        : Navigator.popAndPushNamed(context, '/signup-personal-info');
                  },
                ),
              ),
              SizedBox(
                width: 120,
                child: LoginButton(
                  text: "Next",
                  onPressed: () {
                    signupUserMedicalInfo(context);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
