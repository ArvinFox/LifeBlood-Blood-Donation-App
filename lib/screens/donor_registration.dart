import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lifeblood_blood_donation_app/components/custom_main_app_bar.dart';
import 'package:lifeblood_blood_donation_app/components/login_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/models/user_model.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:lifeblood_blood_donation_app/utils/formatters.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DonorRegistration extends StatefulWidget {
  const DonorRegistration({super.key});

  @override
  State<DonorRegistration> createState() => _DonorRegistrationState();
}

class _DonorRegistrationState extends State<DonorRegistration> {
  final _fullNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _nicController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  final _healthConditionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? selectedGender ;
  String? selectedProvince;
  String? selectedCity;
  String? selectedBloodType;
  bool isSelected = false;
  String? medicalReportBase64;

  final List<String> bloodTypes = ['A+','B+','O+','AB+','A-','B-','O-','AB-'];

  final Map<String, List<String>> provinceCities = {
    'Western': ['Colombo', 'Gampaha', 'Kalutara'],
    'Central': ['Kandy', 'Matale', 'Nuwara Eliya'],
    'Southern': ['Galle', 'Matara', 'Hambantota'],
    'Northern': ['Jaffna', 'Kilinochchi', 'Mannar'],
    'Eastern': ['Trincomalee', 'Batticaloa', 'Ampara'],
    'North Western': ['Kurunegala', 'Puttalam'],
    'North Central': ['Anuradhapura', 'Polonnaruwa'],
    'Uva': ['Badulla', 'Monaragala'],
    'Sabaragamuwa': ['Ratnapura', 'Kegalle'],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;

      if (user != null && user.hasCompletedProfile == true) {
        _fullNameController.text = user.fullName ?? '';
        _contactNumberController.text = user.contactNumber ?? '';
        _nicController.text = user.nic ?? '';
        _addressController.text = user.address ?? '';
        _healthConditionController.text = user.healthConditions ?? '';

        selectedGender = user.gender;
        selectedProvince = user.province;
        selectedCity = user.city;
        selectedBloodType = user.bloodType;

        if (user.dob != null) {
          _selectedDate = user.dob;
          final DateFormat formatter = DateFormat('d-M-yyyy');
          _dobController.text = formatter.format(user.dob!);
        }

        final supabase = Supabase.instance.client;
        final userId = user.userId;
        
        final filesList = await supabase.storage
          .from('medical-reports')
          .list(path: userId);

        FileObject? reportFile;
        try {
          reportFile = filesList.firstWhere((file) => file.name.startsWith('medical_report_'));
        } catch (e) {
          reportFile = null;
        }

        if (reportFile != null) {
          final signedUrlResponse = await supabase.storage
              .from('medical-reports')
              .createSignedUrl('$userId/${reportFile.name}', 60 * 60);

          if (signedUrlResponse.isNotEmpty) {
            setState(() {
              medicalReportBase64 = signedUrlResponse;
            });
          }
        }

        setState(() {
          isSelected = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _contactNumberController.dispose();
    _nicController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _healthConditionController.dispose();
  }

  void _handleFileUploaded(String base64Data) {
    setState(() {
      medicalReportBase64 = base64Data;
    });
  }

  Future<void> submitDonorDetails() async{
    if(_formKey.currentState!.validate() && selectedGender != null && selectedProvince != null && selectedCity != null && selectedBloodType != null && _selectedDate != null && medicalReportBase64 != null && isSelected){
      final user = FirebaseAuth.instance.currentUser?.uid;
      if(user == null){
        Helpers.showError(context, 'User is not logged in.');
        return;
      }

      String formattedContact = Formatters.formatPhoneNumber(_contactNumberController.text.trim());

      if(formattedContact.isEmpty){
        Helpers.showError(context, "Invalid contact number.");
        return;
      }

      final userModel = UserModel(
        fullName: _fullNameController.text.trim(),
        dob: _selectedDate,
        gender: selectedGender,
        nic: _nicController.text.trim(),
        email: FirebaseAuth.instance.currentUser?.email,
        contactNumber: formattedContact,
        address: _addressController.text.trim(),
        city: selectedCity,
        province: selectedProvince,
        bloodType: selectedBloodType,
        healthConditions: _healthConditionController.text.trim(),
        donationCount: 0,
        isActive: true,
        isDonorVerified: false,
        isDonorPromptShown: true,
        createdAt: DateTime.now()
      );

      try{
        await FirebaseFirestore.instance.collection('user').doc(user).update(userModel.toFirestore());

        if(medicalReportBase64 != null && medicalReportBase64.toString().isNotEmpty){
          await uploadMedicalReport(context, medicalReportBase64!, user);
        }

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateStatus(userProvider.user!.userId!, 'hasCompletedProfile', true);

        Helpers.showSucess(context, 'Donor Registration Sucessfully');
        Navigator.pop(context);
        
      } catch (e){
        Helpers.showError(context, 'Error : $e');
      }
    }
  }

  Future<String?> uploadMedicalReport(BuildContext context,String base64Image, String userId) async {
    try {
      // Delete existing files
      // final storage = Supabase.instance.client.storage.from('medical-reports');

      // final List<FileObject>? existingFiles = await storage.list(path: userId);

      // if (existingFiles != null) {
      //   for (final file in existingFiles) {
      //     if (file.name.startsWith('medical_report_')) {
      //       final fullPath = '$userId/${file.name}';
      //       await storage.remove([fullPath]);
      //       Helpers.debugPrintWithBorder('Deleted old report: $fullPath');
      //     }
      //   }
      // }

      final fileBytes = base64Decode(base64Image);

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'medical_report_$userId\_$timestamp.pdf';
      final filePath = '$userId/$fileName';

      await Supabase.instance.client.storage
        .from('medical-reports')
        .uploadBinary(
          filePath,
          fileBytes,
          fileOptions: const FileOptions(contentType: 'application/pdf'), 
        );

      final publicUrl = Supabase.instance.client.storage
        .from('medical-reports')
        .getPublicUrl(filePath);

      Helpers.debugPrintWithBorder('Medical Report uploaded to: $publicUrl');
      return publicUrl;
      
    } catch (e) {
      Helpers.debugPrintWithBorder('Medical Report upload error: $e');
      Helpers.showError(context, "Error uploading medical report.");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: CustomMainAppbar(title: 'Donor Registration', showLeading: true),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInputBox(
                  textName: 'Full Name', 
                  hintText: 'Enter full name here', 
                  controller: _fullNameController
                ),
                _buildDatePicker(
                  'Date Of Birth',
                  _dobController,
                  _selectedDate, 
                  (picked) {
                    setState(() {
                      _selectedDate = picked;
                      _dobController.text ='${picked.day}-${picked.month}-${picked.year}';
                    });
                  },
                  'dd-mm-yyyy'
                ),
                const SizedBox(height: 15),
                Text(
                  "Gender",
                  style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                _buildGenderSelector(),
                const SizedBox(height: 15),
                CustomInputBox(
                  textName: 'Contact Number', 
                  hintText: 'Enter contact number here', 
                  controller: _contactNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                CustomInputBox(
                  textName: 'NIC', 
                  hintText: 'Enter NIC here', 
                  controller: _nicController
                ),
                CustomInputBox(
                  textName: 'Address', 
                  hintText: 'Enter address here', 
                  controller: _addressController
                ),
                _inputBox(
                  _buildDropdown(
                    label: "Province",
                    items: provinceCities.keys.toList(),
                    value: selectedProvince,
                    onChanged: (val) {
                      setState(() {
                        selectedProvince = val;
                        selectedCity = null;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15),
                if (selectedProvince != null)
                  _inputBox(
                    _buildDropdown(
                      label: "City",
                      items: provinceCities[selectedProvince]!,
                      value: selectedCity,
                      onChanged: (val) {
                        setState(() {
                          selectedCity = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                //blood type selection
                const Text(
                  "Blood Type",
                  style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: bloodTypes.map((type) {
                    final selected = selectedBloodType == type;
                    return GestureDetector(
                      onTap:() => setState(() => selectedBloodType = type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                        decoration: BoxDecoration(
                          color: selected ? Colors.redAccent : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? Colors.red : Colors.grey,
                            width: 2,
                          ),
                          boxShadow:
                            selected
                              ? [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.6),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            type,
                            style: TextStyle(
                              fontSize: 18,
                              color: selected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  "Valid Medical Report",
                  style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                if (medicalReportBase64 != null && userProvider.user!.hasCompletedProfile!)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your uploaded report:", style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          launchUrl(Uri.parse(medicalReportBase64!));
                        },
                        child: Text(
                          "View Medical Report",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                SizedBox(height: 15),
                LoginButton(
                  text: 'Submit', 
                  onPressed: (){
                    submitDonorDetails();
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label,TextEditingController controller,DateTime? selectedDate,Function(DateTime) onDateSelected,String? hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime(2005, 12, 31),
              initialEntryMode: DatePickerEntryMode.calendarOnly,
            );
            if (pickedDate != null) {
              onDateSelected(pickedDate);
            }
          },
          validator: (value) =>
                value == null || value.isEmpty ? '* Required' : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return DropdownButtonFormField(
      value: selectedGender,
      items: ["Male", "Female"]
        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
        .toList(),
      onChanged: (value) {
        setState(() => selectedGender = value.toString());
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _inputBox(Widget child) => SizedBox(child: child);

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items:
            items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: (value) => value == null ? 'Required' : null,
        ),
      ],
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
