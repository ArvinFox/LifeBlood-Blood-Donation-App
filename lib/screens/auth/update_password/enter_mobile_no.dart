import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:lifeblood_blood_donation_app/services/otp_service.dart';
import 'package:lifeblood_blood_donation_app/services/user_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import 'package:provider/provider.dart';
import '../../../components/custom_container.dart';

class EnterMobileNumber extends StatefulWidget {

  const EnterMobileNumber({super.key});

  @override
  State<EnterMobileNumber> createState() => _EnterMobileNumberState();
}

class _EnterMobileNumberState extends State<EnterMobileNumber> {
  final TextEditingController _contactNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final OtpService _otpService = OtpService();
  final UserService _userService = UserService();

  bool isLoading = false;

  @override
  void dispose() {
    _contactNumberController.dispose();
    super.dispose();
  }

  void _checkAndSendOtp(String userId) async {
    String contactNumber = _contactNumberController.text.trim();

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
      final user = await _userService.getUserById(userId);

      if (user != null && user.contactNumber == contactNumber) {
        String otp = Helpers.generateOtp();
        bool isOtpSent = await _otpService.sendSMSOtp(contactNumber, otp);

        if (isOtpSent) {
          Helpers.showSucess(context, "OTP sent sucessfully to $contactNumber");

          Navigator.pushNamed(
            context, 
            '/enter-otp', 
            arguments: {
              'contactNumber': contactNumber,
              'otp': otp
            },
          );
        } else {
          Helpers.showError(context, "Failed to send OTP");
        }
      } else {
        Helpers.showError(
          context, 
          "Contact Number not found. Please enter your registered contact number.",
        );
      }

    } catch (e) {
      Helpers.debugPrintWithBorder("Error sending OTP: $e");
      Helpers.showError(context, "An unexpected error occured. Please try again later.");

    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      body: CustomContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Need to Change Password ?',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            Image.asset(
              'assets/images/forgot_pswd.png',
              height: 240,
            ),
            const SizedBox(height: 10),

            const Text(
              'Please enter your registered contact number here. You will receive an OTP to create a new password via mobile number.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            
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
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back to Profile',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),

            CustomButton(
              onPressed: isLoading
                ? null
                : () => _checkAndSendOtp(userProvider.user!.userId!),
              btnLabel: 'Continue',
              buttonChild: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.red,
                      ),
                    )
                  : null,
              cornerRadius: 15,
              btnColor: isLoading ? const Color(0xFFE50F2A) : Colors.white,
              btnBorderColor: const Color(0xFFE50F2A),
              labelColor: isLoading ? Colors.white : const Color(0xFFE50F2A),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
