import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeblood_blood_donation_app/components/text_field.dart';
import 'package:lifeblood_blood_donation_app/models/address_information.dart';
import 'package:lifeblood_blood_donation_app/models/personal_information.dart';
// import 'package:lifeblood_blood_donation_app/services/user_service.dart';
import 'package:lifeblood_blood_donation_app/utils/formatters.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import '../../../components/custom_container.dart';
import '../../../components/login_button.dart';

// ignore: must_be_immutable
class SignupPersonalInfoScreen extends StatefulWidget {
  final String screenTitle;
  PersonalInfo? initialPersonalInfo;
  AddressInfo? initialAddressInfo;

  SignupPersonalInfoScreen({
    super.key,
    required this.screenTitle,
    this.initialPersonalInfo
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
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _dobFocusNode = FocusNode();
  String selectedGender = "Male";
  final _formKey = GlobalKey<FormState>();
  String passwordStrength = '';
  String passwordMatch = '';

  @override
  void initState() {
    super.initState();

    if (widget.initialPersonalInfo != null) {
      _fnameController.text = widget.initialPersonalInfo!.firstName;
      _lnameController.text = widget.initialPersonalInfo!.lastName;
      _dobController.text = Formatters.formatDate(widget.initialPersonalInfo!.dob);
      selectedGender = widget.initialPersonalInfo!.gender;
      _nicController.text = widget.initialPersonalInfo!.nic;
      _licenseController.text = widget.initialPersonalInfo!.drivingLicenseNo ?? '';
      _emailController.text = widget.initialPersonalInfo!.email;
      _contactController.text = widget.initialPersonalInfo!.contactNumber;
      _passwordController.text = widget.initialPersonalInfo!.password;
      _confirmPasswordController.text = widget.initialPersonalInfo!.password;
      passwordStrength = Helpers.checkPasswordStrength(widget.initialPersonalInfo!.password);
      passwordMatch = 'Password Match';
    }
  }

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _dobController.dispose();
    selectedGender = '';
    _nicController.dispose();
    _licenseController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobFocusNode.dispose();
    super.dispose();
  }

  // void checkEmailAvailability() async {
  //   bool isEmailExist = await UserService().emailExistInFirebaseAuth(_emailController.text.trim());
  //   print('---------------$isEmailExist--------------------');
  //   if(isEmailExist){
  //     Helpers.showError(context, "Email is already registered.");
  //     return;
  //   } 
  // }

  void redirectPersonalInfoScreen() async {
    if(_fnameController.text.isEmpty || _lnameController.text.isEmpty || _dobController.text.isEmpty || selectedGender.isEmpty || _nicController.text.isEmpty || _emailController.text.isEmpty || _contactController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty){
      Helpers.showError(context, "All the fields must be completed.");
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        String formattedContact = Formatters.formatPhoneNumber(_contactController.text.trim());

        if(formattedContact.isEmpty){
          Helpers.showError(context, "Invalid contact number.");
          return;
        }

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
          contactNumber: formattedContact,
          password: _passwordController.text.trim(),
        );
        Navigator.pushNamed(context, '/signup-address-info', arguments: {
          'screentitle': widget.screenTitle,
          'personalInfo': personalInfo,
          'addressInfo': widget.initialAddressInfo, 
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
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    PersonalInfo? receivedPersonalInfo = routeArgs?['personalInfo'];
    AddressInfo? receivedAddressInfo = routeArgs?['addressInfo'];

    if (receivedPersonalInfo != null && widget.initialPersonalInfo != receivedPersonalInfo) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          widget.initialPersonalInfo = receivedPersonalInfo;
          _fnameController.text = widget.initialPersonalInfo!.firstName;
          _lnameController.text = widget.initialPersonalInfo!.lastName;
          _dobController.text = Formatters.formatDate(widget.initialPersonalInfo!.dob);
          selectedGender = widget.initialPersonalInfo!.gender;
          _nicController.text = widget.initialPersonalInfo!.nic;
          _licenseController.text = widget.initialPersonalInfo!.drivingLicenseNo ?? '';
          _emailController.text = widget.initialPersonalInfo!.email;
          _contactController.text = widget.initialPersonalInfo!.contactNumber;
          _passwordController.text = widget.initialPersonalInfo!.password;
          _confirmPasswordController.text = widget.initialPersonalInfo!.password;
          passwordStrength = Helpers.checkPasswordStrength(widget.initialPersonalInfo!.password);
          passwordMatch = 'Password Match';
        });
      });
    }

    if (receivedAddressInfo != null && widget.initialAddressInfo != receivedAddressInfo) {
      setState(() {
        widget.initialAddressInfo = receivedAddressInfo;
      });
    }

    return CustomContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                widget.screenTitle == 'profilePage' ? '' : 'Sign Up Here',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
              ),
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
                  fontWeight: FontWeight.w500)
              ),
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
                  ),
                  Text(
                    "Gender",
                    style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  _buildGenderSelector(),
                  SizedBox(height: 10),
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
                    // onChanged: (value){
                    //   checkEmailAvailability();
                    // },
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInputBox(
                        textName: 'Password',
                        hintText: 'Enter your password',
                        controller: _passwordController,
                        hasAstricks: true,
                        onChanged: (value){
                          setState(() {
                            passwordStrength = Helpers.checkPasswordStrength(value);
                          });
                        },
                        validator: (value) {
                          return Helpers.validateInputFields(value, 'Please enter your password here');
                        },
                      ),
                      if (_passwordController.text.isNotEmpty)
                        Text(
                          'Password Strength: ${passwordStrength == 'Weak Password' ? 'Password is too weak. Try using a mix of letters, numbers, and symbols.' : passwordStrength}',
                          style: TextStyle(
                            color: passwordStrength == 'Strong Password'
                                ? Colors.green
                                : passwordStrength == 'Medium Password'
                                    ? Colors.orange
                                    : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      SizedBox(height: 4)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInputBox(
                        textName: 'Confirm Password',
                        hintText: 'Re-Enter your password',
                        controller: _confirmPasswordController,
                        hasAstricks: true,
                        onChanged: (value){
                          setState(() {
                            if(value == _passwordController.text){
                              passwordMatch = 'Password Match';
                            } else{
                              passwordMatch = "Password doesn't match";
                            }
                          });
                        },
                        validator: (value) {
                          return Helpers.validateInputFields(value, 'Please enter your password here');
                        },
                      ),
                      Text(
                        passwordMatch,
                        style: TextStyle(
                          color: passwordMatch == 'Password Match' ? Colors.green : Colors.red
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 120,
                  child: LoginButton(
                    text: "Back",
                    onPressed: () {
                      widget.screenTitle == 'profilePage'
                        ? Navigator.popAndPushNamed(context, '/home_profile')
                        : Navigator.popAndPushNamed(context, '/login');
                    },
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: LoginButton(
                    text: "Next",
                    onPressed: () {
                      redirectPersonalInfoScreen();
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
          style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime(2005, 12, 31),
            );

            if (selectedDate != null) {
              String formattedDate = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
              controller.text = formattedDate;
              FocusScope.of(context).requestFocus(_dobFocusNode);
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              focusNode: _dobFocusNode,
              decoration: InputDecoration(
                hintText: hintText,
                border:OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              validator: validator,
            ),
          ),
        ),
        SizedBox(height: 15),
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
