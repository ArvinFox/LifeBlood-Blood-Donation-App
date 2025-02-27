import 'dart:io';

class User {
  final String userName;
  final String dob;
  final String gender;
  final String nic;
  final String? drivingLicenseNo;
  final String email;
  final int contactNumber;
  final String password;
  final String addressLine1;
  final String addressLine2;
  final String? addressLine3;
  final String city;
  final String province;
  final String bloodType;
  final File medicalReport;
  final String? healthConditions;
  final bool isActive;

  User({
    required this.userName,
    required this.dob,
    required this.gender,
    required this.nic,
    this.drivingLicenseNo,
    required this.email,
    required this.contactNumber,
    required this.password,
    required this.addressLine1,
    required this.addressLine2,
    this.addressLine3,
    required this.city,
    required this.province,
    required this.bloodType,
    required this.medicalReport,
    this.healthConditions,
    required this.isActive,
  });
}
