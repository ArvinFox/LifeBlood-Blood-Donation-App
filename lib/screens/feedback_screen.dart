import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/feedback_model.dart';
import 'package:lifeblood_blood_donation_app/services/feedback_service.dart';
import 'package:lifeblood_blood_donation_app/components/feedback_dialog.dart';
import 'package:lifeblood_blood_donation_app/components/feedback_card.dart';
import 'package:lifeblood_blood_donation_app/components/feedback_custom_button.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackScreen> {
  final FeedbackService _feedbackService = FeedbackService();

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
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 40,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 24,
            right: 16,
            child: FeedbackCustomButton(
              onPressed: () => showFeedbackDialog(context),
              btnLabel: "Add Feedback",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70), // Avoid button overlap
            child: StreamBuilder<List<UserFeedback>>(
              stream: _feedbackService.getFeedbackStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No feedback available"));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return FeedbackCard(feedback: snapshot.data![index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
