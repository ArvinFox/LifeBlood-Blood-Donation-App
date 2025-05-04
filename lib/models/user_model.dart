import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  final String? fullName;
  final DateTime? dob;
  final String? gender;
  final String? nic;
  final String? email;
  final String? contactNumber;
  final String? address;
  final String? city;
  final String? province;
  final String? bloodType;
  final String? healthConditions;
  final int? donationCount;
  final bool? isActive;
  final bool? isDonorVerified;
  final bool? hasCompletedProfile;
  final bool isDonorPromptShown;
  final DateTime? createdAt;
  final DateTime? profileCompletedAt;
  final String? profilePicture;

  UserModel({
    this.userId,
    this.fullName,
    this.dob,
    this.gender,
    this.nic,
    required this.email,
    this.contactNumber,
    this.address,
    this.city,
    this.province,
    this.bloodType,
    this.healthConditions,
    this.donationCount,
    this.isActive,
    this.isDonorVerified,
    this.hasCompletedProfile,
    required this.isDonorPromptShown,
    this.createdAt,
    this.profileCompletedAt,
    this.profilePicture,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'dob': dob != null ? Timestamp.fromDate(dob!) : null,
      'gender': gender,
      'nic': nic,
      'email': email,
      'contactNumber': contactNumber,
      'address': address,
      'city': city,
      'province': province,
      'bloodType': bloodType,
      'healthConditions': healthConditions,
      'donationCount': donationCount,
      'isActive': isActive,
      'isDonorVerified': isDonorVerified,
      'hasCompletedProfile': hasCompletedProfile,
      'isDonorPromptShown': isDonorPromptShown,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'profileCompletedAt': profileCompletedAt != null ? Timestamp.fromDate(profileCompletedAt!) : null,
      'profilePicture': profilePicture,
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data, String userId) {
    return UserModel(
      userId: userId,
      fullName: data['fullName'] ?? '',
      dob: data['dob'] != null ? (data['dob'] as Timestamp).toDate() : null,
      gender: data['gender'] ?? '',
      nic: data['nic'] ?? '',
      email: data['email'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      province: data['province'] ?? '',
      bloodType: data['bloodType'] ?? '',
      healthConditions: data['healthConditions'] ?? '',
      donationCount: data['donationCount'] != null ? data['donationCount'] as int : 0,
      isActive: data['isActive'] as bool? ?? false,
      isDonorVerified: data['isDonorVerified'] as bool? ?? false,
      hasCompletedProfile: data['hasCompletedProfile'] as bool? ?? false,
      isDonorPromptShown: data['isDonorPromptShown'] as bool? ?? false,
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
      profileCompletedAt: data['profileCompletedAt'] != null ? (data['profileCompletedAt'] as Timestamp).toDate() : null,
      profilePicture: data['profilePicture'],
    );
  }
}
