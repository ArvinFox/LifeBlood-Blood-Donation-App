class UserFeedback{
  final int feedbackId;
  final int userId;
  final String feedbackContent;
  final int rating;
  final DateTime createdAt;

  UserFeedback({
    required this.feedbackId,
    required this.userId,
    required this.feedbackContent,
    required this.rating,
    required this.createdAt
  });
}