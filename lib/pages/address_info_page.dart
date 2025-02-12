import 'package:flutter/material.dart';
import '../widgets/custom_container.dart'; // Reusing the custom container layout
import '../widgets/login_button.dart'; // Reusing the login button

class AddressInfoPage extends StatefulWidget {
  const AddressInfoPage({super.key});

  @override
  State<AddressInfoPage> createState() => _AddressInfoPageState();
}

class _AddressInfoPageState extends State<AddressInfoPage> {
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
          Center(
            child: Text("Address Information",
                style: TextStyle(fontSize: 18, color: Colors.red)),
          ),
          SizedBox(height: 15),
          Text("Address Line 1"),
          TextField(
            controller: address1Controller,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 10),
          Text("Address Line 2"),
          TextField(
            controller: address2Controller,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 10),
          Text("Address Line 3"),
          TextField(
            controller: address3Controller,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 10),
          Text("City"),
          TextField(
            controller: cityController,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 10),
          Text("Province"),
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 120, // Reduced button width
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
                  text: "Sign Up",
                  onPressed: () {
                    // Sign-up logic here
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
