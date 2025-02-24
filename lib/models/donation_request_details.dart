class DonationRequestDetails {
  final String requestBloodType;
  final String urgencyLevel;
  final String hospitalLocation;
  final String city;

  DonationRequestDetails({
    required this.requestBloodType,
    required this.urgencyLevel,
    required this.hospitalLocation,
    required this.city,
  });
}

List<DonationRequestDetails> requestDetails = [
  DonationRequestDetails(
    requestBloodType: 'A+',
    urgencyLevel: "High",
    hospitalLocation: "Base Hospital ",
    city: "Homagama",
  ),
  DonationRequestDetails(
    requestBloodType: 'B+',
    urgencyLevel: "High",
    hospitalLocation: "Base Hospital ",
    city: "Homawgama",
  ),
  DonationRequestDetails(
    requestBloodType: 'AB+',
    urgencyLevel: "High",
    hospitalLocation: "Base Hospital ",
    city: "Homawgama",
  ),
  DonationRequestDetails(
    requestBloodType: 'O+',
    urgencyLevel: "High",
    hospitalLocation: "Base Hospital ",
    city: "Homawgama",
  ),
];
