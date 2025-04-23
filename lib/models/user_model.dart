import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  final String? fullName;
  final DateTime? dob;
  final String? gender;
  final String? nic;
  final String? drivingLicenseNo;
  final String email;
  final String? contactNumber;
  final String? address;
  final String? city;
  final String? province;
  final String? bloodType;
  String? medicalReport;
  final String? healthConditions;
  final bool? isActive;
  final bool isDonorPromptShown;
  final DateTime createdAt;

  UserModel({
    this.userId,
    this.fullName,
    this.dob,
    this.gender,
    this.nic,
    this.drivingLicenseNo,
    required this.email,
    this.contactNumber,
    this.address,
    this.city,
    this.province,
    this.bloodType,
    this.medicalReport,
    this.healthConditions,
    this.isActive,
    required this.isDonorPromptShown,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'dob': dob != null ? Timestamp.fromDate(dob!) : null,
      'gender': gender,
      'nic': nic,
      'drivingLicenseNo': drivingLicenseNo,
      'email': email,
      'contactNumber': contactNumber,
      'address': address,
      'city': city,
      'province': province,
      'bloodType': bloodType,
      'healthConditions': healthConditions,
      'isActive': isActive,
      'isDonorPromptShown': isDonorPromptShown,
      'created_at': createdAt
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data, String userId) {
    return UserModel(
      userId: userId,
      fullName: data['fullName'] ?? '',
      dob: data['dob'] != null ? (data['dob'] as Timestamp).toDate() : null,
      gender: data['gender'] ?? '',
      nic: data['nic'] ?? '',
      drivingLicenseNo: data['drivingLicenseNo'] ?? '',
      email: data['email'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      province: data['province'] ?? '',
      bloodType: data['bloodType'] ?? '',
      healthConditions: data['healthConditions'] ?? '',
      isActive: data['isActive'] as bool? ?? false,
      isDonorPromptShown: data['isDonorPromptShown'] as bool? ?? false,
      createdAt: data['created_at'] != null ? (data['created_at'] as Timestamp).toDate() : DateTime.now(),
    );
  }
}
