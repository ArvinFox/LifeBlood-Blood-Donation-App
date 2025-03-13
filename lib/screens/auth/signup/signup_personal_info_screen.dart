import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/models/personal_information.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import '../../../components/custom_container.dart';
import '../../../components/login_button.dart';

class SignupPersonalInfoScreen extends StatefulWidget {
  final String screenTitle;

  const SignupPersonalInfoScreen({
    super.key,
    required this.screenTitle,
  });

  @override
  State<SignupPersonalInfoScreen> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<SignupPersonalInfoScreen> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String selectedGender = "Male";
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _nicController.dispose();
    _licenseController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void signupUserPersonalInfo() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        DateTime? dob = Helpers.setDob(_dobController.text.trim());
        if (dob == null) {
          Helpers.showError(context, "Invalid Date of Birth format. Please use YYYY-MM-DD.");
          return;
        }

        PersonalInfo personalInfo = PersonalInfo(
          userId: '',
          firstName: _fnameController.text.trim(),
          lastName: _lnameController.text.trim(),
          dob: dob,
          gender: selectedGender,
          nic: _nicController.text.trim(),
          drivingLicenseNo: _licenseController.text.trim(),
          email: _emailController.text.trim(),
          contactNumber: _contactController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Navigator.pushNamed(context, '/signup-address-info', arguments: {
          'screentitle': widget.screenTitle,
          'personalInfo': personalInfo,
        });
      } catch (e) {
        Helpers.showError(context, "Error");
      }
    } else {
      Helpers.showError(context, "Passwords are doesn't match");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                  widget.screenTitle == 'profilePage' ? '' : 'Sign Up Here',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                  widget.screenTitle == 'profilePage'
                      ? 'Edit Personal Information'
                      : 'Personal Information',
                  style: TextStyle(
                      fontSize: 18,
                      color: const Color(0xFFE50F2A),
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: 15),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInputBox(
                    textName: 'First Name',
                    hintText: 'Enter your first name',
                    controller: _fnameController,
                    validator: (value) {
                      return Helpers.validateInputFields(value, 'Please enter your first name here');
                    },
                  ),
                  CustomInputBox(
                    textName: 'Last Name',
                    hintText: 'Enter your last name',
                    controller: _lnameController,
                    validator: (value) {
                      return Helpers.validateInputFields(value, 'Please enter your last name here');
                    },
                  ),
                  _buildDatePicker(
                     labelText: 'Date of Birth',
                    hintText: 'YYYY-MM-DD',
                    controller: _dobController,
                    context: context,
                    validator: Helpers.validateDate,
                  ),
                  Text(
                    "Gender",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  _buildGenderSelector(),
                  SizedBox(
                    height: 10,
                  ),
                  CustomInputBox(
                    textName: 'NIC',
                    hintText: 'Enter your NIC number',
                    controller: _nicController,
                    validator: (value) {
                      return Helpers.validateInputFields(value, 'Please enter your NIC here');
                    },
                  ),
                  CustomInputBox(
                    textName: 'Driving License Number (opt)',
                    hintText: 'Enter your license number',
                    controller: _licenseController,
                  ),
                  CustomInputBox(
                    textName: 'Email',
                    hintText: 'Enter your Email',
                    controller: _emailController,
                    validator: Helpers.validateEmail,
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
                    validator: (value) {
                      return Helpers.validateInputFields(value, 'Please enter your contact number here');
                    },
                  ),
                  CustomInputBox(
                    textName: 'Password',
                    hintText: 'Enter your password',
                    controller: _passwordController,
                    hasAstricks: true,
                    validator: (value) {
                      return Helpers.validateInputFields(value, 'Please enter your password here');
                    },
                  ),
                  CustomInputBox(
                    textName: 'Confirm Password',
                    hintText: 'Enter your password again',
                    controller: _confirmPasswordController,
                    hasAstricks: true,
                    validator: (value) {
                      return Helpers.validateInputFields(value, 'Please enter your password here');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 120,
                  child: LoginButton(
                    text: "Back",
                    onPressed: () {
                      widget.screenTitle == 'profilePage'
                          ? Navigator.popAndPushNamed(context, '/profile')
                          : Navigator.popAndPushNamed(context, '/login');
                    },
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: LoginButton(
                    text: "Next",
                    onPressed: () {
                      signupUserPersonalInfo();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required String labelText,
    required String hintText,
    required TextEditingController controller,
    required BuildContext context,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );

            if (selectedDate != null) {
              String formattedDate =
                  '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
              controller.text = formattedDate;
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              validator: validator,
            ),
          ),
        ),
        SizedBox(
          height: 15,
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
}
