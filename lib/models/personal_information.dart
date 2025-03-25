import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';

class PersonalInfo {
  String userId;
  final String firstName;
  final String lastName;
  final DateTime dob;
  final String gender;
  final String nic;
  final String? drivingLicenseNo;
  final String email;
  final String contactNumber;
  final String password;

  PersonalInfo({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.nic,
    this.drivingLicenseNo,
    required this.email,
    required this.contactNumber,
    required this.password,
  });

  Map<String, dynamic> toFirestore() {
    Helpers helper = Helpers();

    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'dob': Timestamp.fromDate(dob),
      'gender': gender,
      'nic': nic,
      'drivingLicenseNo': drivingLicenseNo,
      'email': email,
      'contactNumber': contactNumber,
      'password': helper.hashPassword(password),
    };
  }

  factory PersonalInfo.fromFirestore(Map<String, dynamic> data) {
    return PersonalInfo(
      userId: data['userId'],
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      dob: (data['dob'] as Timestamp).toDate(),
      gender: data['gender'] ?? '',
      nic: data['nic'] ?? '',
      drivingLicenseNo: data['drivingLicenseNo'] ?? '',
      email: data['email'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      password: data['password'] ?? '',
    );
  }
}
