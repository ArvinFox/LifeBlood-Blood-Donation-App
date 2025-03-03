import 'package:flutter/material.dart';

class BloodRequestCard extends StatelessWidget {
  final String bloodType;
  final String urgencyLevel;
  final String location;
  final String contactInfo;

  const BloodRequestCard({
    super.key,
    required this.bloodType,
    required this.urgencyLevel,
    required this.location,
    required this.contactInfo,
  });

  // Confirm Dialog Box
  void showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure, that you want to confirm?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 30),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side:
                        const BorderSide(color: Color(0xFFE50F2A), width: 1.5),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Color(0xFFE50F2A)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circular Blood Type Indicator
                  Container(
                    width: 60,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFE50F2A), width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      bloodType,
                      style: TextStyle(
                          color: Color(0xFFE50F2A), fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 15), // Space between circle and text
                
                  // Expanded to prevent overflow
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            children: [
                              TextSpan(
                                  text: "Blood Type: ",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: bloodType),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            children: [
                              TextSpan(
                                  text: "Urgency Level: ",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: urgencyLevel),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            children: [
                              TextSpan(
                                  text: "Location: ",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: location,
                                style: TextStyle(overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          softWrap: false, // Prevents breaking into two lines
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            children: [
                              TextSpan(
                                  text: "Contact: ",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: contactInfo),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14), // Space before button
                
              // Confirm Button
              ElevatedButton(
                onPressed: () {
                  showConfirmDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE50F2A),
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  "Confirm",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
