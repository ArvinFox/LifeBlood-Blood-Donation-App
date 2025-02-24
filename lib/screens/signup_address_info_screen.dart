import 'package:flutter/material.dart';
import '../components/custom_container.dart';
import '../components/login_button.dart';

class SignupAddressInfoScreen extends StatefulWidget {
  const SignupAddressInfoScreen({super.key});

  @override
  State<SignupAddressInfoScreen> createState() => _AddressInfoPageState();
}

class _AddressInfoPageState extends State<SignupAddressInfoScreen> {
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController address3Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  String selectedProvince = "Central Province";

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          Center(
            child: Text("Address Information",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFE50F2A),
                    fontWeight: FontWeight.w500)),
          ),
          SizedBox(height: 25),
          Text("Address Line 1"),
          SizedBox(height: 5),
          TextField(
            controller: address1Controller,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 20),
          Text("Address Line 2"),
          SizedBox(height: 5),
          TextField(
            controller: address2Controller,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 20),
          Text("Address Line 3"),
          SizedBox(height: 5),
          TextField(
            controller: address3Controller,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 20),
          Text("City"),
          SizedBox(height: 5),
          TextField(
            controller: cityController,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 20),
          Text("Province"),
          SizedBox(height: 5),
          DropdownButtonFormField(
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
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                width: 120, // Reduced button width
                child: LoginButton(
                  text: "Next",
                  onPressed: () {
                    // Sign-up logic here
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MedicalInfoPage(),
                    //   ),
                    // );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
