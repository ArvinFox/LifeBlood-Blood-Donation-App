import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/feedback_model.dart';
import 'package:lifeblood_blood_donation_app/models/user_model.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackScreen> {
  final List<UserFeedback> feedbackList = [
    UserFeedback(
      feedbackId: 1,
      userId: 1,
      feedbackContent:
          "This app has the potential to save lives. It's amazing how quickly I could connect with a donor.",
      createdAt: DateTime(2025, 3, 7),
      rating: 5,
    ),
    UserFeedback(
      feedbackId: 2,
      userId: 1,
      feedbackContent:
          "The app is very user-friendly and easy to navigate. I found a donor quickly!",
      createdAt: DateTime(2025, 3, 7),
      rating: 5,
    ),
  ];

  final List<User> userList = [
    User(
      userId: 1,
      firstName: "Nimal",
      lastName: "Perera",
      registrationDate: DateTime(2025, 3, 7),
      dob: DateTime(1997, 3, 7),
      gender: "male",
      nic: "97876543234v",
      email: "nimal@gmail.com",
      contactNumber: 0778976543,
      password: "12345",
      addressLine1: "No.100/8",
      addressLine2: "Homagama",
      city: "Homagama",
      province: "Colombo",
      bloodType: "A+",
      medicalReport: File('path_to_your_medical_report.pdf'),
      isActive: true,
    )
  ];

  int ratingCount = 0;

  void _showFeedbackDialog() {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        const Text(
                          "Give Us a Feedback!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE50F2A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black54),
                          onPressed: () {
                            ratingCount = 0;
                            commentController.clear();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Your feedback is important for us. We take your feedback very seriously.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => IconButton(
                          onPressed: () {
                            setState(() {
                              ratingCount = index + 1;
                            });
                          },
                          icon: Icon(
                            Icons.star,
                            size: 32,
                            color: index < ratingCount
                                ? Colors.amber
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: "Add a comment",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE50F2A),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          ratingCount = 0;
                          commentController.clear();
                          Navigator.pop(context);
                        });
                      },
                      child: const Text(
                        "Submit Feedback",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE50F2A),
        title: const Text(
          "Feedback",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: CupertinoNavigationBarBackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        leadingWidth: 40,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.topRight, // Moves button to top right
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50F2A),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _showFeedbackDialog,
                child: const Text(
                  "Add Feedback",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                User user = userList.firstWhere(
                    (user) => user.userId == feedbackList[index].userId);
                return _buidFeedbackCard(
                  feedback: feedbackList[index],
                  user: user,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buidFeedbackCard(
      {required UserFeedback feedback, required User user}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            feedback.feedbackContent,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "- ${user.firstName} ${user.lastName}-",
            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                color: Colors.amber,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
