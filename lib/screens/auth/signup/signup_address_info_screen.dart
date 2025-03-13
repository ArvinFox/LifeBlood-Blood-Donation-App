import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/models/address_information.dart';
import 'package:lifeblood_blood_donation_app/models/personal_information.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import '../../../components/custom_container.dart';
import '../../../components/login_button.dart';

class SignupAddressInfoScreen extends StatefulWidget {
  final String screenTitle;
  final PersonalInfo personalInfo;

  const SignupAddressInfoScreen(
    {
      super.key,
      required this.screenTitle,
      required this.personalInfo
    }
  );

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

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _addressLine3Controller.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void signupUserAddressInfo() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      try {
        AddressInfo addressInfo = AddressInfo(
          addressLine1: _addressLine1Controller.text.trim(),
          addressLine2: _addressLine2Controller.text.trim(),
          addressLine3: _addressLine3Controller.text.trim(),
          city: _cityController.text.trim(),
          province: selectedProvince,
        );

        Navigator.pushNamed(context, '/signup-medical-info', arguments: {
          'screenTitle': widget.screenTitle,
          'personalInfo': widget.personalInfo,
          'addressInfo': addressInfo
        });
      } catch (e) {
        Helpers.showError(context, "Error");
      }
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
                    return Helpers.validateInputFields(
                        value, 'Please enter your address here');
                  },
                ),
                CustomInputBox(
                  textName: 'Address Line 2',
                  hintText: 'Enter your address',
                  controller: _addressLine2Controller,
                  validator: (value) {
                    return Helpers.validateInputFields(
                        value, 'Please enter your address here');
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
                    return Helpers.validateInputFields(
                        value, 'Please enter your city here');
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
                _buidProvinceSelector()
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
                            arguments: {
                              'screenTitle': widget.screenTitle,
                              'personalInfo': widget.personalInfo,
                            }
                          )
                        : Navigator.popAndPushNamed(
                            context, '/signup-personal-info', 
                            arguments: {
                              'screenTitle': widget.screenTitle,
                              'personalInfo': widget.personalInfo,
                            }
                          );
                  },
                ),
              ),
              SizedBox(
                width: 120,
                child: LoginButton(
                  text: "Next",
                  onPressed: () {
                    signupUserAddressInfo();
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

  Widget _buidProvinceSelector() {
    return DropdownButtonFormField(
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
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        setState(() => selectedProvince = value.toString());
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
