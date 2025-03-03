import 'package:flutter/material.dart';

void showConfirmationPopup(BuildContext context, String bloodType,
    String urgencyLevel, String hospital, String city) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Lifesaving Alert: Donate Blood Now!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/images/emergency.jpg",
                width: 120,
                height: 140,
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Blood Type : $bloodType",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Urgency Level : $urgencyLevel",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Location : $hospital - \n$city",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      content: Text(
        "Your timely blood donation can save lives and bring hope to those in critical need. Act now to be a hero!",
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Confirm", style: TextStyle(color: Colors.white)),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style:
                  OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ],
    ),
  );
}
