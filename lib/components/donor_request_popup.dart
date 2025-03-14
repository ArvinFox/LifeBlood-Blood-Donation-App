import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/small_button.dart';

class RequestPopupMessage extends StatelessWidget {
  final TextEditingController patientName;
  final String bloodType;
  final TextEditingController hospitalName;
  final TextEditingController city;
  final VoidCallback onClearFields;

  const RequestPopupMessage(
      {super.key,
      required this.patientName,
      required this.bloodType,
      required this.hospitalName,
      required this.city,
      required this.onClearFields});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              onClearFields();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      titlePadding: EdgeInsets.all(10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your request has been \nsubmitted successfully..',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 300,
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient Name: ${patientName.text}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
                Text(
                  'Blood Type: $bloodType',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
                Text(
                  'Location: ${hospitalName.text}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
                Text(
                  'City: ${city.text}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: SmallButton(
            buttonWidth: 100,
            buttonHeight: 40,
            buttonLabel: 'OK',
            buttonColor: Color(0xFFEB1C36),
            borderColor: Color(0xFFEB1C36),
            labelColor: Colors.white,
            onTap: () {
              onClearFields();
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
