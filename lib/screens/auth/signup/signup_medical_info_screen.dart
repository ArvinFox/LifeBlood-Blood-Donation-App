import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/blood_type_card.dart';
import 'package:lifeblood_blood_donation_app/components/custom_container.dart';
import 'package:lifeblood_blood_donation_app/components/login_button.dart';
import 'package:lifeblood_blood_donation_app/components/medical_report_picker.dart';
import 'package:lifeblood_blood_donation_app/models/address_information.dart';
import 'package:lifeblood_blood_donation_app/models/blood_type.dart';
import 'package:lifeblood_blood_donation_app/models/medical_information.dart';
import 'package:lifeblood_blood_donation_app/models/personal_information.dart';
import 'package:lifeblood_blood_donation_app/models/user_model.dart';
import 'package:lifeblood_blood_donation_app/services/auth_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';

class SignupMedicalInfoScreen extends StatefulWidget {
  final String screenTitle;
  final PersonalInfo personalInfo;
  final AddressInfo addressInfo;

  const SignupMedicalInfoScreen({
    super.key,
    required this.screenTitle,
    required this.personalInfo,
    required this.addressInfo,
  });

  @override
  State<SignupMedicalInfoScreen> createState() =>
      _SignupMedicalInfoScreenState();
}

class _SignupMedicalInfoScreenState extends State<SignupMedicalInfoScreen> {
  final TextEditingController _healthConditionController = TextEditingController();
  String selectBloodType = '';
  bool isSelected = false;
  String? medicalReport;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _healthConditionController.dispose();
    super.dispose();
  }

  void signupUserRedirect() {
    final auth = AuthService();

    if (!isSelected) {
      Helpers.showError(
          context, 'You must agree to the terms and conditions to continue');
      return;
    }

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      if (medicalReport == null) {
        Helpers.showError(context, 'Please upload valid medical file');
        return;
      }
      MedicalInfo medicalInfo = MedicalInfo(
        bloodType: selectBloodType,
        healthConditions: _healthConditionController.text,
        registrationDate: DateTime.now(),
        medicalReport: medicalReport,
      );

      UserModel userModel = UserModel(
        personalInfo: widget.personalInfo,
        addressInfo: widget.addressInfo,
        medicalInfo: medicalInfo,
        isActive: isSelected,
      );

      try {
        auth.addUser(userModel);

        if (widget.screenTitle == 'profilePage') {
          Navigator.popAndPushNamed(context, '/profile');
        } else {
          Navigator.popAndPushNamed(context, '/login');
        }
      } catch (e) {
        Helpers.showError(context, "Error");
      }
    } else {
      Helpers.showError(context, "Please fill all the fields correctly");
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
                    ? 'Edit Medical Information'
                    : 'Medical Information',
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
                Text(
                  "Blood Type",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                //Blood types
                Container(
                  height: 180,
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 25,
                    children: List.generate(bloodTypes.length, (index) {
                      return BloodTypeCard(
                        bloodType: bloodTypes[index].bloodType,
                        isSelected: bloodTypes[index].isSelected,
                        onSelect: () {
                          setState(() {
                            for (var type in bloodTypes) {
                              //for deselect all other blood types
                              type.isSelected = false;
                            }
                            //select the current blood tpye
                            bloodTypes[index].isSelected = true;
                            selectBloodType = bloodTypes[index].bloodType;
                          });
                        },
                      );
                    }),
                  ),
                ),
                Text(
                  "Valid medical report",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                //file picker for select medical report
                MedicalReportPicker(
                  onFileUploaded: (file) {
                    setState(() {
                      medicalReport = file; 
                    });
                  },
                ),
                SizedBox(height: 15),
                Text(
                  "Medical Conditions",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _healthConditionController,
                  maxLines: 20,
                  minLines: 1,
                  validator: (value) {
                    return Helpers.validateInputFields(
                        value, 'Please enter your health conditions');
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your health conditions',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            isSelected = value!;
                          });
                        }),
                    Text('I agree to the terms and conditions'),
                  ],
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
                            context,
                            '/signup-address-info',
                            arguments: {
                              'screenTitle': widget.screenTitle,
                              'personalInfo': widget.personalInfo,
                              'addressInfo': widget.addressInfo,
                            },
                          )
                        : Navigator.popAndPushNamed(
                            context,
                            '/signup-address-info',
                            arguments: {
                              'screenTitle': widget.screenTitle,
                              'personalInfo': widget.personalInfo,
                              'addressInfo': widget.addressInfo,
                            },
                          );
                  },
                ),
              ),
              SizedBox(
                width: 120,
                child: LoginButton(
                  text:
                      widget.screenTitle == 'profilePage' ? 'Save' : 'Sign Up',
                  onPressed: () {
                    signupUserRedirect();
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
