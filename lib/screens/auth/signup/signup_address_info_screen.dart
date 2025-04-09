import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/models/address_information.dart';
import 'package:lifeblood_blood_donation_app/models/medical_information.dart';
import 'package:lifeblood_blood_donation_app/models/personal_information.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import '../../../components/custom_container.dart';
import '../../../components/login_button.dart';

// ignore: must_be_immutable
class SignupAddressInfoScreen extends StatefulWidget {
  final String screenTitle;
  final PersonalInfo personalInfo;
  AddressInfo? initialAddressInfo;
  MedicalInfo? initialMedicalInfo;

  SignupAddressInfoScreen({
    super.key,
    required this.screenTitle,
    required this.personalInfo,
    this.initialAddressInfo,
  });

  @override
  State<SignupAddressInfoScreen> createState() => _AddressInfoPageState();
}

class _AddressInfoPageState extends State<SignupAddressInfoScreen> {
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _addressLine3Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String? selectedProvince ;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if(widget.initialAddressInfo != null){
      _addressLine1Controller.text = widget.initialAddressInfo!.addressLine1;
      _addressLine2Controller.text = widget.initialAddressInfo!.addressLine2;
      _addressLine3Controller.text = widget.initialAddressInfo!.addressLine3 ?? '';
      _cityController.text = widget.initialAddressInfo!.city;
      selectedProvince = widget.initialAddressInfo!.province;
    }
  }

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _addressLine3Controller.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void redirectMedicalInfoScreen() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      try {
        AddressInfo addressInfo = AddressInfo(
          addressLine1: _addressLine1Controller.text.trim(),
          addressLine2: _addressLine2Controller.text.trim(),
          addressLine3: _addressLine3Controller.text.trim(),
          city: _cityController.text.trim(),
          province: selectedProvince!,
        );

        Navigator.pushNamed(context, '/signup-medical-info', arguments: {
          'screenTitle': widget.screenTitle,
          'personalInfo': widget.personalInfo,
          'addressInfo': addressInfo,
          'medicalInfo': widget.initialMedicalInfo
        });
      } catch (e) {
        Helpers.showError(context, "Error");
      }
    }
  }

  void goBackPersonalInfoScreen(){
    if (selectedProvince == null ||_addressLine1Controller.text.trim().isEmpty || _addressLine2Controller.text.trim().isEmpty || _cityController.text.trim().isEmpty) {
      Navigator.pop(context);
      return;
    }

    AddressInfo addressInfo = AddressInfo(
      addressLine1: _addressLine1Controller.text.trim(),
      addressLine2: _addressLine2Controller.text.trim(),
      addressLine3: _addressLine3Controller.text.trim(),
      city: _cityController.text.trim(),
      province: selectedProvince!,
    );

    Navigator.pushNamed(
      context,
      '/signup-personal-info',
      arguments: {
        'screenTitle': widget.screenTitle,
        'personalInfo': widget.personalInfo,
        'addressInfo': addressInfo,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    AddressInfo? receivedAddressInfo = routeArgs?['addressInfo'];
    MedicalInfo? receivedMedicalInfo = routeArgs?['medicalInfo'];

    if(receivedAddressInfo != null && widget.initialAddressInfo != receivedAddressInfo){
      WidgetsBinding.instance.addPostFrameCallback((_){
        setState(() {
          widget.initialAddressInfo = receivedAddressInfo;
          _addressLine1Controller.text = widget.initialAddressInfo!.addressLine1;
          _addressLine2Controller.text = widget.initialAddressInfo!.addressLine2;
          _addressLine3Controller.text = widget.initialAddressInfo!.addressLine3 ?? '';
          _cityController.text = widget.initialAddressInfo!.city;
          selectedProvince = widget.initialAddressInfo!.province;
        });
      });
    }

    if (receivedMedicalInfo != null && widget.initialMedicalInfo != receivedMedicalInfo) {
      setState(() {
        widget.initialMedicalInfo = receivedMedicalInfo;
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
                ? 'Edit Address Information'
                : 'Address Information',
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
                CustomInputBox(
                  textName: 'Address Line 1',
                  hintText: 'Enter your address',
                  controller: _addressLine1Controller,
                  validator: (value) {
                    return Helpers.validateInputFields(value, 'Please enter your address here');
                  },
                ),
                CustomInputBox(
                  textName: 'Address Line 2',
                  hintText: 'Enter your address',
                  controller: _addressLine2Controller,
                  validator: (value) {
                    return Helpers.validateInputFields(value, 'Please enter your address here');
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
                    return Helpers.validateInputFields(value, 'Please enter your city here');
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
                      : goBackPersonalInfoScreen();
                  },
                ),
              ),
              SizedBox(
                width: 120,
                child: LoginButton(
                  text: "Next",
                  onPressed: () {
                    redirectMedicalInfoScreen();
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
