import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/feedback_container.dart';
import 'package:lifeblood_blood_donation_app/models/feedback.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackScreen> {
  final List<UserFeedback> feedbackList = [
    UserFeedback(
      userName: 'Jane Smith',
      content: "This app has the potential to save lives. It's amazing how quickly I could connect with a donor.",
      rating: 5,
    ),
    UserFeedback(
      userName: 'John Dave',
      content: "The app is very user-friendly and easy to navigate. I found a donor quickly!",
      rating: 5,
    ),
  ];

  void _showFeedbackDialog() {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40), // Spacer to balance the title
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
                        // Handle the Rating functionality
                      },
                      icon: const Icon(
                        Icons.star,
                        size: 32,
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
                  onPressed: () {},
                  child: const Text(
                    "Submit Feedback",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
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
                return FeedbackContainer(feedback: feedbackList[index],);
              },
            ),
          ),
        ],
      ),
    );
  }
}
