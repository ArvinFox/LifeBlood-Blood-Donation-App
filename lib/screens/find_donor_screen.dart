import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeblood_blood_donation_app/components/blood_type_card.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/donor_request_popup.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/models/blood_type.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';

class FindDonorScreen extends StatefulWidget {
  final NavigationPage navigation;

  const FindDonorScreen({
    super.key,
    required this.navigation,
  });

  @override
  State<FindDonorScreen> createState() => _FindDonorScreenState();
}

class _FindDonorScreenState extends State<FindDonorScreen> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String selectBloodType = '';
  String urgencyLevel = 'Select Urgency Level';
  String selectedProvince = 'Western Province';

  final CollectionReference requestCollection =
      FirebaseFirestore.instance.collection('requests');

  @override
  void dispose() {
    _patientNameController.dispose();
    _contactController.dispose();
    _hospitalNameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _clearInputFields() {
    _patientNameController.clear();
    _hospitalNameController.clear();
    _contactController.clear();
    _cityController.clear();
    setState(() {
      selectBloodType = '';
      bloodTypes = bloodTypes.map((type) {
        return BloodType(bloodType: type.bloodType, isSelected: false);
      }).toList();
    });
  }

  void submitRequest() async {
    try {
      DonationRequestDetails request = DonationRequestDetails(
        requestId: '',
        patientName: _patientNameController.text.trim(),
        requestBloodType: selectBloodType,
        urgencyLevel: urgencyLevel,
        hospitalName: _hospitalNameController.text.trim(),
        contactNumber: _contactController.text.trim(),
        city: _cityController.text.trim(),
        province: selectedProvince,
        createdAt: DateTime.now()
      );
      await requestCollection.doc().set(request.toFirestore());

    } catch (e) {
      Helpers.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFE50F2A),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Find Donors",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading:
            widget.navigation == NavigationPage.sideDrawer ? true : false,
        leading: widget.navigation == NavigationPage.sideDrawer
            ? CupertinoNavigationBarBackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        leadingWidth: 40,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInputBox(
                textName: 'Patient Name',
                hintText: 'Enter patient name',
                controller: _patientNameController,
              ),
              CustomInputBox(
                textName: 'Contact Number',
                hintText: 'Enter Contact Number',
                controller: _contactController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              Text(
                "Blood Type",
                style: TextStyle(
                  fontSize: 18,
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
              SizedBox(height: 15),
              Text(
                "Urgency Level",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              _buildUrgencyLevelSelector(),
              SizedBox(height: 10),
              CustomInputBox(
                textName: 'Hospital Name',
                hintText: 'Enter hospital name',
                controller: _hospitalNameController,
              ),
              CustomInputBox(
                textName: 'City',
                hintText: 'Enter city',
                controller: _cityController,
              ),
              SizedBox(height: 15),
              Text(
                "Province",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              _buidProvinceSelector(),
              SizedBox(height: 25),
              //submit button with popup message
              Center(
                child: CustomButton(
                  btnLabel: 'Submit Request',
                  cornerRadius: 20,
                  btnColor: Colors.white,
                  btnBorderColor: Colors.red,
                  labelColor: Colors.red,
                  onPressed: () {
                    if (_patientNameController.text.isEmpty ||
                        _contactController.text.isEmpty ||
                        _hospitalNameController.text.isEmpty ||
                        selectBloodType.isEmpty) {
                      Helpers.showError(context, 'Please fill in all the fields');
                    } else {
                      submitRequest();
                      //display popup message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RequestPopupMessage(
                            patientName: _patientNameController,
                            bloodType: selectBloodType,
                            hospitalName: _hospitalNameController,
                            city: _cityController,
                            onClearFields: () {
                              _clearInputFields();
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUrgencyLevelSelector() {
    return DropdownButtonFormField(
      value: urgencyLevel,
      items: ["Select Urgency Level", "High", "Low"]
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        setState(() => urgencyLevel = value.toString());
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
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

enum NavigationPage {
  bottomNavigation,
  sideDrawer,
  roleSelection,
}
