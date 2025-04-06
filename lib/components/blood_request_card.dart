import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';

class BloodRequestCard extends StatelessWidget {
  final DonationRequestDetails bloodRequestDetails;
  final Function onConfirm; // Add the onConfirm callback

  const BloodRequestCard({
    super.key,
    required this.bloodRequestDetails,
    required this.onConfirm, // Accept the onConfirm callback
  });

  // Confirm Dialog Box
  void showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Are you sure, that you want to confirm?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    onConfirm(); // Call the confirm function
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
                    Navigator.pop(context); // Just close the dialog
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
                      bloodRequestDetails
                          .requestBloodType, // Blood Type from Firestore
                      style: const TextStyle(
                          color: Color(0xFFE50F2A),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Expanded to prevent overflow
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.black, fontSize: 13),
                            children: [
                              const TextSpan(
                                  text: "Blood Type: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: bloodRequestDetails.requestBloodType),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.black, fontSize: 13),
                            children: [
                              const TextSpan(
                                  text: "Urgency Level: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: bloodRequestDetails.urgencyLevel),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.black, fontSize: 13),
                            children: [
                              const TextSpan(
                                  text: "Location: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: bloodRequestDetails.hospitalName,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          softWrap: false, // Prevents breaking into two lines
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.black, fontSize: 13),
                            children: [
                              const TextSpan(
                                  text: "Contact: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: bloodRequestDetails.contactNumber),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Confirm Button
              ElevatedButton(
                onPressed: () {
                  showConfirmDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50F2A),
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
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
