class DonationRequestDetails {
  final int requestId;
  final String name;
  final String requestBloodType;
  final String urgencyLevel;
  final String location;
  final String city;
  final String contactNumber;

  DonationRequestDetails({
    required this.requestId,
    required this.name,
    required this.requestBloodType,
    required this.urgencyLevel,
    required this.location,
    required this.contactNumber, 
    required this.city,
  });
}
