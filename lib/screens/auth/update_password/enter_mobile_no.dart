import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/services/otp_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import '../../../components/custom_container.dart';

class EnterMobileNumber extends StatefulWidget {

  const EnterMobileNumber({super.key});

  @override
  State<EnterMobileNumber> createState() => _EnterMobileNumberState();
}

class _EnterMobileNumberState extends State<EnterMobileNumber> {
  final TextEditingController _contactNumberController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    _contactNumberController.dispose();
  }

  void _checkAndSendOtp() async {
    String contactNumber = _contactNumberController.text.trim();
    OtpService otpService = OtpService();

    if (contactNumber.startsWith('0')) {
      // ignore: prefer_interpolation_to_compose_strings
      contactNumber = '+94' + contactNumber.substring(1);
    }

    if (contactNumber.length != 12) {
      Helpers.showError(context, "Please enter a valid mobile number");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot query = await firestore
          .collection('user')
          .where('personalInfo.contactNumber', isEqualTo: contactNumber)
          .get();

      if (query.docs.isNotEmpty) {
        //send Otp
        String otp = Helpers.generateOtp();
        bool isOtpSent = await otpService.sendSMSOtp(contactNumber, otp);

        if (isOtpSent) {
          Helpers.showSucess(context, "OTP sent sucessfully to $contactNumber");

          Navigator.pushNamed(context, '/enter-otp', arguments: {
            'contactNumber': contactNumber,
            'otp': otp
          });
        } else {
          Helpers.showError(context, "Failed to send OTP");
        }
      } else {
        Helpers.showError(
            context, "Contact Number not found.Please try again later.");
      }
    } catch (e) {
      Helpers.showError(context, "An error occured");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Need to Change Password ?',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Image.asset(
              'assets/images/forgot_pswd.png',
              height: 240,
            ),
            SizedBox(height: 10),
            Text(
              'Please enter your registered contact number here. You will receive an OTP to create a new password via mobile number.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: CustomInputBox(
                textName: 'Contact Number',
                hintText: 'Enter Contact Number',
                controller: _contactNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
            ),

            // back to login
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.popAndPushNamed(context, '/profile');
                },
                child: Text(
                  'Back to Profile',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              onPressed: isLoading
                  ? null
                  : () {
                      _checkAndSendOtp();
                    },
              btnLabel: 'Continue',
              buttonChild: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.red,
                      ),
                    )
                  : null,
              cornerRadius: 15,
              btnColor: isLoading ? Color(0xFFE50F2A) : Colors.white,
              btnBorderColor: Color(0xFFE50F2A),
              labelColor: isLoading ? Colors.white : Color(0xFFE50F2A),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
