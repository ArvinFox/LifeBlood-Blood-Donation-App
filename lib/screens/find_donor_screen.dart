import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/blood_type_card.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/donor_request_popup.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/models/blood_type.dart';

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
  final TextEditingController _locationController = TextEditingController();
  String selectBloodType = '';

  void _clearInputFields() {
    _patientNameController.clear();
    _locationController.clear();
    setState(() {
      selectBloodType = '';
      bloodTypes = bloodTypes.map((type) {
        return BloodType(bloodType: type.bloodType, isSelected: false);
      }).toList();
    });
  }

  void _errorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Please fill in all the fields....",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.3),
      ),
    );
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInputBox(
                textName: 'Patient Name',
                hintText: 'Enter patient name',
                controller: _patientNameController,
              ),
              Text(
                "Blood Type",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 15,
              ),
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
              SizedBox(
                height: 15,
              ),
              CustomInputBox(
                textName: 'Location',
                hintText: 'Enter location',
                controller: _locationController,
              ),
              SizedBox(
                height: 25,
              ),
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
                        _locationController.text.isEmpty ||
                        selectBloodType.isEmpty) {
                      _errorMessage();
                    } else {
                      //display popup message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RequestPopupMessage(
                            patientNameController: _patientNameController,
                            bloodType: selectBloodType,
                            locationController: _locationController,
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
}

enum NavigationPage {
  bottomNavigation,
  sideDrawer,
  roleSelection,
}
