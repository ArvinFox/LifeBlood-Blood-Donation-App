class Hospital{
  final int hospitalId;
  final String hospitalName;
  final String city;
  final String province;
  final String contactNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  Hospital({
    required this.hospitalId,
    required this.hospitalName,
    required this.city,
    required this.province,
    required this.contactNumber,
    required this.createdAt,
    required this.updatedAt
  });
}