class DonationEvents{
  final int eventId;
  final String eventName;
  final String eventPosterUrl;
  final String description;
  final DateTime createdAt;

  DonationEvents({
    required this.eventId,
    required this.eventName, 
    required this.eventPosterUrl,
    required this.description,
    required this.createdAt,
  });
}