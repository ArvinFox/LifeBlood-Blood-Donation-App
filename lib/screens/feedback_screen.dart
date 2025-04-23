import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_main_app_bar.dart';
import 'package:lifeblood_blood_donation_app/models/feedback_model.dart';
import 'package:lifeblood_blood_donation_app/services/feedback_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackScreen> {
  final FeedbackService _feedbackService = FeedbackService();
  final TextEditingController commentController = TextEditingController();
  int ratingCount = 0;

  void showFeedbackDialog(BuildContext context){
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
                    _dialogHeader(),
                    const SizedBox(height: 8),
                    const Text(
                      "Your feedback is important for us. We take your feedback very seriously.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    _ratingStars(
                      (rating) => setState(() => ratingCount = rating),
                    ),
                    const SizedBox(height: 10),
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
                    _buildCustomButton(
                      () async {
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
                      'Submit Feedback'
                    )
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
      appBar: CustomMainAppbar(title: 'Feedback', showLeading: true),
      body: Stack(
        children: [
          Positioned(
            top: 24,
            right: 16,
            child: _buildCustomButton(
              (){
                showFeedbackDialog(context);
              },
              "Add Feedback"
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70), 
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
                    return _feedbackCard(snapshot.data![index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedbackCard(UserFeedback feedback) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                color: index < feedback.rating ? Colors.amber : Colors.grey,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Custom button
  Widget _buildCustomButton(VoidCallback onPressed,String btnLabel){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(140, 45), 
        backgroundColor: Color(0xFFE50F2A),
        side: BorderSide(color: Colors.transparent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        btnLabel,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  //Header Widget (Title + Close Button)
  Widget _dialogHeader(){
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
          onPressed: (){
            ratingCount = 0;
            commentController.clear();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  // Star Rating Widget
  Widget _ratingStars(ValueChanged<int> onRate){
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
