import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/feedback_model.dart';
import 'package:lifeblood_blood_donation_app/services/feedback_service.dart';
import 'package:lifeblood_blood_donation_app/components/feedback_custom_button.dart';

void showFeedbackDialog(BuildContext context) {
  final FeedbackService _feedbackService = FeedbackService();
  final TextEditingController commentController = TextEditingController();
  int ratingCount = 0;

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
                  _DialogHeader(
                    onClose: () {
                      ratingCount = 0;
                      commentController.clear();
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Your feedback is important for us. We take your feedback very seriously.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  _RatingStars(
                    ratingCount: ratingCount,
                    onRate: (rating) => setState(() => ratingCount = rating),
                  ),
                  const SizedBox(height: 10),
                  _FeedbackTextField(controller: commentController),
                  const SizedBox(height: 20),
                  FeedbackCustomButton(
                    onPressed: () async {
                      if (ratingCount > 0 &&
                          commentController.text.isNotEmpty) {
                        UserFeedback feedback = UserFeedback(
                          feedbackId: DateTime.now().millisecondsSinceEpoch,
                          feedbackContent: commentController.text,
                          rating: ratingCount,
                          createdAt: DateTime.now(),
                        );

                        await _feedbackService.addFeedback(feedback);
                        ratingCount = 0;
                        commentController.clear();
                        Navigator.pop(context);
                      }
                    },
                    btnLabel: "Submit Feedback",
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

/// *Header Widget (Title + Close Button)*
class _DialogHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _DialogHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
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
          onPressed: onClose,
        ),
      ],
    );
  }
}

/// *Star Rating Widget*
class _RatingStars extends StatelessWidget {
  final int ratingCount;
  final ValueChanged<int> onRate;

  const _RatingStars({required this.ratingCount, required this.onRate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => IconButton(
          onPressed: () => onRate(index + 1),
          icon: Icon(
            Icons.star,
            size: 32,
            color: index < ratingCount ? Colors.amber : Colors.grey,
          ),
        ),
      ),
    );
  }
}

/// *TextField for Feedback Input*
class _FeedbackTextField extends StatelessWidget {
  final TextEditingController controller;

  const _FeedbackTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Add a comment",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      maxLines: 3,
    );
  }
}
