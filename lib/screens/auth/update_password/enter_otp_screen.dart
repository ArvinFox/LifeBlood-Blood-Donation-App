import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeblood_blood_donation_app/components/custom_button.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/services/otp_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
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
  OtpService _otpService = OtpService();

  bool _isLoading = false;
  bool _isOtpSent = true;
  int _remainingTime = 30;
  Timer? _timer;
  String? _generatedOtp;
  DateTime? _otpExpiryTime;

  @override
  void initState() {
    super.initState();

    if (widget.otp.isNotEmpty) {
      setState(() {
        _generatedOtp = widget.otp;
        _otpExpiryTime = DateTime.now().add(Duration(minutes: 3));
      });

      _startTimer();
    }
  }

  Future<void> _resendOtp() async {
    if (_isOtpSent) {
      Helpers.showError(context, "Please wait $_remainingTime seconds before requesting another OTP.");
      return;
    }

    String otp = Helpers.generateOtp();
    bool isSuccess = await _otpService.sendSMSOtp(widget.contactNumber, otp);

    if (isSuccess) {
      setState(() {
        _isLoading = false;
        _isOtpSent = true;
        _otpExpiryTime = DateTime.now().add(Duration(minutes: 3));
        _remainingTime = 30;
        _generatedOtp = otp;
      });

      _startTimer();

      Helpers.showSucess(context, "OTP sent to ${widget.contactNumber}");

    } else {
      await Future.delayed(Duration(milliseconds: 250));
      Helpers.showError(context, "Failed to resend OTP. Please try again.");
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
      }
    });
  }

  Future<bool> _verifyOtp(String enteredOtp) async {
    if (enteredOtp.isEmpty) {
      Helpers.showError(context, "Please enter OTP.");
      return false;
    }

    if (_generatedOtp == null || _otpExpiryTime == null) {
      await Future.delayed(Duration(seconds: 1));
      Helpers.showError(context, "OTP has expired. Please request a new one.");
      return false;
    }

    if (DateTime.now().isAfter(_otpExpiryTime!)) {
      await Future.delayed(Duration(seconds: 1));
      Helpers.showError(context, "OTP has expired. Please request a new one.");
      return false;
    }

    if (enteredOtp != _generatedOtp) {
      await Future.delayed(Duration(seconds: 1));
      Helpers.showError(context, "Invalid OTP. Please try again.");
      return false;
    }

    setState(() {
      _generatedOtp = null;
      _otpExpiryTime = null;
    });
    
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  Future<void> _handleOtpVerification() async {
    setState(() => _isLoading = true);
    bool isCorrectOtp = await _verifyOtp(_otpController.text);
    setState(() => _isLoading = false);

    if (isCorrectOtp) {
      Navigator.pushNamed(
        context, 
        '/new-password', 
        arguments: {
          'contactNumber': widget.contactNumber,
        },
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
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
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => _resendOtp(),
                child: Text(
                  _isOtpSent
                      ? "Resend OTP in $_remainingTime seconds"
                      : "Resend OTP",
                  style: TextStyle(
                    color: _isOtpSent ? Colors.grey : Colors.red,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            CustomButton(
              onPressed: _isLoading
                ? null
                : () => _handleOtpVerification(),
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
