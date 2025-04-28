import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeblood_blood_donation_app/components/custom_main_app_bar.dart';
import 'package:lifeblood_blood_donation_app/components/drawer/side_drawer.dart';
import 'package:lifeblood_blood_donation_app/components/login_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';
import 'package:lifeblood_blood_donation_app/models/notification_model.dart';
import 'package:lifeblood_blood_donation_app/providers/notification_provider.dart';
import 'package:lifeblood_blood_donation_app/services/request_service.dart';
import 'package:lifeblood_blood_donation_app/services/user_service.dart';
import 'package:lifeblood_blood_donation_app/utils/formatters.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import 'package:provider/provider.dart';

class RequestDonors extends StatefulWidget {
  final NavigationPage navigation;

  const RequestDonors({
    super.key,
    required this.navigation,
  });

  @override
  State<RequestDonors> createState() => _RequestDonorsState();
}

class _RequestDonorsState extends State<RequestDonors> {
  final _patientNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserService userService = UserService();
  final RequestService requestService = RequestService();

  String? selectedBloodType;
  String? selectedUrgency;
  String? selectedQuantity;
  String? selectedProvince;
  String? selectedCity;
  String? selectedHospital;

  final List<String> bloodTypes = [
    'A+',
    'B+',
    'O+',
    'AB+',
    'A-',
    'B-',
    'O-',
    'AB-'
  ];
  final List<String> urgencyLevels = ['Low', 'Medium', 'High'];
  final List<String> bloodquantity = ['1 Pint', '2 Pints', '3 Pints'];

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

  final Map<String, List<String>> cityHospitals = {
    'Colombo': [
      'Jayawardenapura General Hospital',
      'Castle Ladies Hospital',
      'National Hospital Colombo',
      'Asiri Surgical',
      'Lanka Hospitals',
      'Nawaloka Hospital',
    ],
    'Gampaha': ['Gampaha General Hospital', 'Nawaloka Negombo'],
    'Kalutara': [
      'Kalutara General Hospital',
      'Nagoda Hospital',
      'Horana General Hospital',
    ],
    'Kandy': ['Kandy General Hospital', 'Suwasevana Hospital'],
    'Matale': ['Matale District Hospital'],
    'Nuwara Eliya': ['Nuwara Eliya Base Hospital'],
    'Galle': ['Karapitiya Teaching Hospital', 'Mahamodara Hospital'],
    'Matara': ['Matara General Hospital'],
    'Hambantota': ['Hambantota District General Hospital'],
    'Jaffna': ['Jaffna Teaching Hospital'],
    'Kilinochchi': ['Kilinochchi District Hospital'],
    'Mannar': ['Mannar District Hospital'],
    'Trincomalee': ['Trincomalee General Hospital'],
    'Batticaloa': ['Batticaloa Teaching Hospital'],
    'Ampara': ['Ampara General Hospital'],
    'Kurunegala': ['Kurunegala Teaching Hospital'],
    'Puttalam': ['Puttalam District Hospital'],
    'Anuradhapura': ['Anuradhapura Teaching Hospital'],
    'Polonnaruwa': ['Polonnaruwa General Hospital'],
    'Badulla': ['Badulla General Hospital'],
    'Monaragala': ['Monaragala District Hospital'],
    'Ratnapura': ['Ratnapura General Hospital'],
    'Kegalle': ['Kegalle General Hospital'],
  };

  @override
  void dispose() {
    _patientNameController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (_formKey.currentState!.validate() &&
        selectedUrgency != null &&
        selectedQuantity != null &&
        selectedProvince != null &&
        selectedCity != null &&
        selectedHospital != null &&
        selectedBloodType != null &&
        _patientNameController.text.isNotEmpty &&
        _contactNumberController.text.isNotEmpty) {
      _showConfirmationDialog();
    } else {
      Helpers.showError(context, "Please fill all fields");
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Please Confirm Details",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: Container(
          width: 1000.0,
          child: SingleChildScrollView(
            child: Table(
              border: TableBorder.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              columnWidths: const {
                0: FixedColumnWidth(140),
                1: FlexColumnWidth(),
              },
              children: [
                Helpers.buildTableRow(
                    "Patient Name", _patientNameController.text),
                Helpers.buildTableRow(
                    "Contact Number", _contactNumberController.text),
                Helpers.buildTableRow("Blood Type", selectedBloodType!),
                Helpers.buildTableRow("Urgency Level", selectedUrgency!),
                Helpers.buildTableRow("Quantity", selectedQuantity!),
                Helpers.buildTableRow("Province", selectedProvince!),
                Helpers.buildTableRow("City", selectedCity!),
                Helpers.buildTableRow("Hospital", selectedHospital!),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              submitRequest();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
            ),
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  void submitRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Helpers.showError(context, "You must be logged in to make a request.");
      return;
    }

    final userData = await userService.getUserById(user.uid);

    if (userData == null || userData.fullName == null) {
      Helpers.showError(context, "User data not found.");
      return;
    }

    String formattedContact =
        Formatters.formatPhoneNumber(_contactNumberController.text.trim());

    BloodRequest request = BloodRequest(
      patientName: _patientNameController.text,
      requestedBy: userData.fullName!,
      contactNumber: formattedContact,
      requestBloodType: selectedBloodType!,
      urgencyLevel: selectedUrgency!,
      requestQuantity: selectedQuantity!,
      province: selectedProvince!,
      city: selectedCity!,
      hospitalName: selectedHospital!,
      createdAt: DateTime.now(),
    );

    try {
      final requestId = await requestService.createRequest(request);

      final notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);
      final users = await userService.getAllUsers();
      for (var user in users) {
        if (user != null &&
            user.isDonorVerified! &&
            user.bloodType! == selectedBloodType) {
          final notification = NotificationModel(
            userId: user.userId!,
            requestId: requestId,
            type: 'new_request',
            isRead: false,
            timestamp: DateTime.now(),
          );
          notificationProvider.createNotification(notification);
        }
      }

      print("Request saved successfully!");
      resetForm();
      Navigator.pushNamed(context, '/home');
      Helpers.showSucess(context, "Request submitted!");
    } catch (e) {
      print("Error saving request: $e");
      Helpers.showError(context, "Failed to submit request");
    }
  }

  void resetForm() {
    _patientNameController.clear();
    _contactNumberController.clear();
    setState(() {
      selectedBloodType = null;
      selectedUrgency = null;
      selectedQuantity = null;
      selectedProvince = null;
      selectedCity = null;
      selectedHospital = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomMainAppbar(
        title: 'Request Donor',
        showLeading: widget.navigation != NavigationPage.bottomNavigation,
        automaticallyImplyLeading:
            widget.navigation == NavigationPage.sideDrawer,
      ),
      endDrawer: NavDrawer(),
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
                  textName: 'Patient Name',
                  hintText: 'Enter patient name',
                  controller: _patientNameController,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Required'
                      : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                  ],
                ),
                CustomInputBox(
                  textName: 'Contact Number',
                  hintText: 'Enter Contact Number',
                  controller: _contactNumberController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    } else if (value.trim().length != 10) {
                      return 'Phone number should contain 10 digits';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                //province selection
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
                  //city selection
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
                if (selectedCity != null)
                  //hospital name selection
                  _inputBox(
                    _buildDropdown(
                      label: "Hospital",
                      items: cityHospitals[selectedCity]!,
                      value: selectedHospital,
                      onChanged: (val) =>
                          setState(() => selectedHospital = val),
                    ),
                  ),
                const SizedBox(height: 15),
                //blood type selection
                const Text(
                  "Blood Type",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: bloodTypes.map((type) {
                    final selected = selectedBloodType == type;
                    return GestureDetector(
                      onTap: () => setState(() => selectedBloodType = type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: selected ? Colors.redAccent : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? Colors.red : Colors.grey,
                            width: 2,
                          ),
                          boxShadow: selected
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
                const SizedBox(height: 15),
                //urgency level selection
                _inputBox(
                  _buildDropdown(
                    label: "Urgency Level",
                    items: urgencyLevels,
                    value: selectedUrgency,
                    onChanged: (val) => setState(() => selectedUrgency = val),
                  ),
                ),
                const SizedBox(height: 15),
                //quantity selection
                _inputBox(
                  _buildDropdown(
                    label: "Required Quantity",
                    items: bloodquantity,
                    value: selectedQuantity,
                    onChanged: (val) => setState(() => selectedQuantity = val),
                  ),
                ),
                const SizedBox(height: 40),
                LoginButton(
                    text: 'Submit',
                    onPressed: () {
                      submitForm();
                    })
              ],
            ),
          ),
        ),
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
        Text(label,
            style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          value: value,
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: items
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

enum NavigationPage { bottomNavigation, sideDrawer }
