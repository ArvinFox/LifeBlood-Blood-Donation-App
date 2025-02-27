import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/blood_type_card.dart';
import 'package:lifeblood_blood_donation_app/components/custom_container.dart';
import 'package:lifeblood_blood_donation_app/components/login_button.dart';
import 'package:lifeblood_blood_donation_app/models/blood_type.dart';

class SignupMedicalInfoScreen extends StatefulWidget {
  final String screenTitle;

  const SignupMedicalInfoScreen({
    super.key,
    required this.screenTitle,
  });

  @override
  State<SignupMedicalInfoScreen> createState() =>
      _SignupMedicalInfoScreenState();
}

class _SignupMedicalInfoScreenState extends State<SignupMedicalInfoScreen> {
  final TextEditingController _healthConditionController =
      TextEditingController();
  String selectBloodType = '';
  final _formKey = GlobalKey<FormState>();

  void signupUserRedirectHome(context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      //Navigator.pushReplacementNamed(context, '/login');
      widget.screenTitle == 'profilePage'
          ? Navigator.popAndPushNamed(context, '/profile')
          : Navigator.popAndPushNamed(context, '/login');
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
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      // final result = await FilePicker.platform.pickFiles();
                      // if (result == null) {
                      //   print('No file selected.');
                      //   return;
                      // }
                      // print('File selected: ${result.files.single.name}');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.black38))),
                    child: Text(
                      'Select Medical Report',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter your health conditions';
                    }
                    return null;
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
                            context, '/signup-address-info',
                            arguments: widget.screenTitle)
                        : Navigator.popAndPushNamed(
                            context, '/signup-address-info');
                  },
                ),
              ),
              SizedBox(
                width: 120,
                child: LoginButton(
                  text: widget.screenTitle == 'profilePage'
                      ? 'Save'
                      : 'Sign Up',
                  onPressed: () {
                    signupUserRedirectHome(context);
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
