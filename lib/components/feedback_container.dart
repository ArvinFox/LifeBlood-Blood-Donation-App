import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/feedback.dart';


class FeedbackContainer extends StatelessWidget {
  final UserFeedback feedback;

  const FeedbackContainer({
    super.key,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
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
            feedback.content,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "- ${feedback.userName} -",
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
