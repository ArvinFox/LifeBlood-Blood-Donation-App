import 'package:lifeblood_blood_donation_app/models/address_information.dart';
import 'package:lifeblood_blood_donation_app/models/medical_information.dart';
import 'package:lifeblood_blood_donation_app/models/personal_information.dart';

class UserModel {
  final PersonalInfo personalInfo;
  final AddressInfo addressInfo;
  final MedicalInfo medicalInfo;
  final bool isActive;

  UserModel({
    required this.personalInfo,
    required this.addressInfo,
    required this.medicalInfo,
    required this.isActive,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'personalInfo': personalInfo.toFirestore(),
      'addressInfo': addressInfo.toFirestore(),
      'medicalInfo': medicalInfo.toFirestore(),
      'isActive': isActive,
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data, String userId) {
    return UserModel(
      personalInfo: data['personalInfo'],
      addressInfo: data['addressInfo'],
      medicalInfo: data['medicalInfo'],
      isActive: data['isActive'] ?? '',
    );
  }
}
