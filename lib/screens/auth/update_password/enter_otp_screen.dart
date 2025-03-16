import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/services/otp_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/custom_container.dart';

class EnterOtpScreen extends StatefulWidget {
  final String contactNumber;
  final String otp;

  const EnterOtpScreen({
    super.key,
    required this.contactNumber,
    required this.otp
  });

  @override
  State<EnterOtpScreen> createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  OtpService otpService = OtpService();
  bool _isLoading = false;
  bool _isOtpSent = false;
  int _remainingTime = 30;
  Timer? _timer;
  String _currentOtp = '';

  @override
  void initState() {
    super.initState();
    if(widget.otp.isNotEmpty){
     setState(() {
        _isOtpSent = true;
        _currentOtp = widget.otp;
     });
     _startTimer();
    }
  }

  void verifyOtp() {
    setState(() {
      _isLoading = true;
    });

    String enteredOtp = _otpController.text.trim();

    if(_remainingTime <=0){
      Helpers.showError(context, "OTP has expired. Please request a new one.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (enteredOtp == _currentOtp) {
      Helpers.showSucess(context, "OTP verified sucessfully");
      Navigator.pushNamed(context, '/new-password', arguments: {
        'contactNumber': widget.contactNumber,
      });
    } else {
      Helpers.showError(context, "Invalid OTP. Please try again");
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isOtpSent = false;
        });

        SharedPreferences.getInstance().then((prefs) {
          prefs.setBool('isOtpSent', false);
          prefs.setInt('remainingTime', 0);
        });
      }
    });
  }

  Future<void> _reSendOtp({bool isResend = false}) async {
    if (isResend && _isOtpSent) {
      Helpers.showError(context, "Please wait $_remainingTime seconds before requesting another OTP.");
      return;
    }

    String otp = Helpers.generateOtp();
    bool isSuccess = await otpService.sendSMSOtp(widget.contactNumber, otp);

    if (isSuccess) {
      setState(() {
        _isLoading = false;
        _isOtpSent = true;
        _remainingTime = 30;
        _currentOtp = otp;
      });

      _startTimer();

      Helpers.showSucess(context, "OTP sent again to ${widget.contactNumber}");

    } else if (isResend) {
      await Future.delayed(Duration(milliseconds: 250));
      Helpers.showError(context, "Failed to resend OTP. Please try again.");;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _otpController.dispose();
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
            SizedBox(height: 20),
            Image.asset('assets/images/otp.png', height: 230),
            SizedBox(height: 20),
            Text(
              'Enter the OTP here...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: CustomInputBox(
                textName: 'OTP',
                hintText: 'Enter your OTP',
                controller: _otpController,
                hasAstricks: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () async {
                  if(!_isOtpSent){
                    _reSendOtp(isResend: true);
                  }
                },
                child: Text(
                  _isOtpSent
                      ? "Resend OTP in $_remainingTime seconds"
                      : "Resend OTP",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 40),
            CustomButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      verifyOtp();
                    },
              btnLabel: 'Continue',
              buttonChild: _isLoading
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
              btnColor: _isLoading ? Color(0xFFE50F2A) : Colors.white,
              btnBorderColor: Color(0xFFE50F2A),
              labelColor: _isLoading ? Colors.white : Color(0xFFE50F2A),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
