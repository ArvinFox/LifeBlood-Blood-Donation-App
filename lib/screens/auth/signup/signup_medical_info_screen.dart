import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/blood_type_card.dart';
import 'package:lifeblood_blood_donation_app/components/custom_container.dart';
import 'package:lifeblood_blood_donation_app/components/login_button.dart';
import 'package:lifeblood_blood_donation_app/models/address_information.dart';
import 'package:lifeblood_blood_donation_app/models/blood_type.dart';
import 'package:lifeblood_blood_donation_app/models/medical_information.dart';
import 'package:lifeblood_blood_donation_app/models/personal_information.dart';
import 'package:lifeblood_blood_donation_app/models/user_model.dart';
import 'package:lifeblood_blood_donation_app/services/user_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class SignupMedicalInfoScreen extends StatefulWidget {
  final String screenTitle;
  final PersonalInfo personalInfo;
  final AddressInfo addressInfo;
  MedicalInfo? initialMedicalInfo;

  SignupMedicalInfoScreen({
    super.key,
    required this.screenTitle,
    required this.personalInfo,
    required this.addressInfo,
    this.initialMedicalInfo
  });

  @override
  State<SignupMedicalInfoScreen> createState() => _SignupMedicalInfoScreenState();
}

class _SignupMedicalInfoScreenState extends State<SignupMedicalInfoScreen> {
  final TextEditingController _healthConditionController = TextEditingController();
  String selectBloodType = '';
  bool isSelected = false;
  String? medicalReportBase64;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if(widget.initialMedicalInfo != null){
      selectBloodType = widget.initialMedicalInfo!.bloodType;
      medicalReportBase64 = widget.initialMedicalInfo!.medicalReport;
      _healthConditionController.text = widget.initialMedicalInfo!.healthConditions ?? '';
    }
  }

  @override
  void dispose() {
    _healthConditionController.dispose();
    for (var type in bloodTypes) {
      type.isSelected = false;
    }
    medicalReportBase64 = null;
    super.dispose();
  }

  void _handleFileUploaded(String base64Data) {
    setState(() {
      medicalReportBase64 = base64Data;
    });
  }

  Future<void> signupUser(BuildContext context) async {
    final auth = UserService();

    if (!isSelected) {
      Helpers.showError(context, 'You must agree to the terms and conditions to continue');
      return;
    }

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      if (medicalReportBase64 == null) {
        Helpers.showError(context, 'Please upload valid medical file');
        return;
      }
      MedicalInfo medicalInfo = MedicalInfo(
        bloodType: selectBloodType,
        healthConditions: _healthConditionController.text,
        registrationDate: DateTime.now(),
      );

      UserModel userModel = UserModel(
        personalInfo: widget.personalInfo,
        addressInfo: widget.addressInfo,
        medicalInfo: medicalInfo,
        isActive: isSelected,
      );

      try {
        final userId = await auth.addUser(userModel);

        if (userId != null) {
          final fileName = 'medical_report_$userId.${medicalReportBase64!.substring(0, 10)}.pdf';
          final filePath = '$userId/$fileName';

          final response = await Supabase.instance.client.storage
              .from('medical-reports')
              .uploadBinary(
                filePath,
                base64Decode(medicalReportBase64!),
                fileOptions: const FileOptions(contentType: 'application/pdf'),
              );

          if (response != null) {
            final fileUrl = Supabase.instance.client.storage
                .from('medical-reports')
                .getPublicUrl(filePath);

            userModel.medicalInfo.medicalReport = fileUrl;
            Helpers.debugPrintWithBorder('Medical report uploaded to: $fileUrl');

            if (widget.screenTitle == 'profilePage') {
              Navigator.popAndPushNamed(context, '/profile');
              Helpers.showSucess(context, "Your information has been updated.");
            } else {
              Navigator.popAndPushNamed(context, '/login');
              Helpers.showSucess(context, "Login using email and password.");
            }
          } else {
            Helpers.showError(context, "Failed to upload medical report.");
          }
        } else {
          Helpers.showError(context, "Failed to create user account.");
        }
      } catch (e) {
        print('Error during signup: $e');
        if(e is Exception){
          print('---------------${e}-----------------------');
          if(e == 'Exception: email-already-in-use'){
            Helpers.showError(context, "Email is already registered.");
          } else{
            Helpers.showError(context, "Error during signup.");
          }
        }
      }
    } else {
      Helpers.showError(context, "Please fill all the fields correctly");
    }
  }

  void redirectAddressInfoScreen(){
    if(selectBloodType.isEmpty ||  _healthConditionController.text.trim().isEmpty || medicalReportBase64 == null){
      Navigator.pop(context);
      return;
    }
    
    MedicalInfo medicalInfo =MedicalInfo(
      bloodType: selectBloodType, 
      medicalReport: medicalReportBase64, 
      registrationDate: DateTime.now(),
      healthConditions: _healthConditionController.text.trim()
    );

    Navigator.pushNamed(
      context,
      '/signup-address-info',
      arguments: {
        'screenTitle': widget.screenTitle,
        'personalInfo': widget.personalInfo,
        'addressInfo': widget.addressInfo,
        'medicalInfo': medicalInfo,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    MedicalInfo? receivedMedicalInfo = routeArgs?['medicalInfo'];

    if(receivedMedicalInfo != null && widget.initialMedicalInfo != receivedMedicalInfo){
      WidgetsBinding.instance.addPostFrameCallback((_){
        setState(() {
          widget.initialMedicalInfo = receivedMedicalInfo;
          selectBloodType = widget.initialMedicalInfo!.bloodType;
          _healthConditionController.text = widget.initialMedicalInfo!.healthConditions ?? '';
          medicalReportBase64 = widget.initialMedicalInfo!.medicalReport;
        });
      });
    }
    
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
                fontWeight: FontWeight.w500)
            ),
          ),
          SizedBox(height: 25),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Blood Type",
                  style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                //file picker for select medical report
                MedicalReportPicker(
                  onFileUploaded: _handleFileUploaded,
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
                SizedBox(height: 15),
                TextFormField(
                  controller: _healthConditionController,
                  maxLines: 20,
                  minLines: 1,
                  validator: (value) {
                    return Helpers.validateInputFields(value, 'Please enter your health conditions');
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your health conditions',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 15),
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
                      : redirectAddressInfoScreen();
                  },
                ),
              ),
              SizedBox(
                width: 120,
                child: LoginButton(
                  text: widget.screenTitle == 'profilePage' ? 'Save' : 'Sign Up',
                  onPressed: () {
                    signupUser(context);
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


class MedicalReportPicker extends StatefulWidget {
  final Function(String)? onFileUploaded;

  const MedicalReportPicker({super.key, this.onFileUploaded});

  @override
  State<MedicalReportPicker> createState() => _MedicalReportPickerState();
}

class _MedicalReportPickerState extends State<MedicalReportPicker> {
  String text = 'Select Medical Report';
  Color btnColor = Colors.white;

  Future<void> uploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
    );

    if (result != null) {
      final filePath = result.files.single.path;
      final fileName = result.files.single.name;

      if (filePath != null) {
        try {
          final fileBytes = await File(filePath).readAsBytes();
          String base64String = base64Encode(fileBytes);

          setState(() {
            text = fileName.length > 20
                ? "${fileName.substring(0, 20)}...."
                : fileName;
            btnColor = Colors.red;
          });

          if (widget.onFileUploaded != null) {
            widget.onFileUploaded!(base64String); 
          }
        } catch (e) {
          print('Error while reading or encoding the file: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: uploadFile,
        style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black38))),
        child: Text(
          text,
          style: TextStyle(
              color: btnColor == Colors.red ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }
}
