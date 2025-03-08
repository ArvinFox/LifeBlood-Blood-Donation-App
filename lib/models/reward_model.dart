class Rewards{
  final int rewardId;
  final String rewardTitle;
  final String rewardDescription;
  final String rewardPosterUrl;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  
  Rewards({
    required this.rewardId,
    required this.rewardTitle,
    required this.rewardDescription,
    required this.rewardPosterUrl,
    required this.startDate,
    required this.endDate,
    required this.createdAt
  });
}