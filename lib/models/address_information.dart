class AddressInfo{
  final String addressLine1;
  final String addressLine2;
  final String? addressLine3;
  final String city;
  final String province;

  AddressInfo({
    required this.addressLine1,
    required this.addressLine2,
    this.addressLine3,
    required this.city,
    required this.province,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'addressLine3': addressLine3,
      'city': city,
      'province': province,
    };
  }

  factory AddressInfo.fromFirestore(Map<String, dynamic> data) {
    return AddressInfo(
      addressLine1: data['addressLine1'] ?? '',
      addressLine2: data['addressLine2'] ?? '',
      addressLine3: data['addressLine3'] ?? '',
      city: data['city'] ?? '',
      province: data['province'] ?? '',
    );
  }
}
