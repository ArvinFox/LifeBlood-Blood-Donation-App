//import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final DateTime dob;
  final String gender;
  final String nic;
  final String? drivingLicenseNo;
  final String email;
  final String contactNumber;
  final String password;
  final String addressLine1;
  final String addressLine2;
  final String? addressLine3;
  final String city;
  final String province;
  final String bloodType;
  //final File medicalReport;
  final String? healthConditions;
  final bool isActive;
  final DateTime registrationDate;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.registrationDate,
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
    //required this.medicalReport,
    this.healthConditions,
    required this.isActive,
  });

  // Convert Firestore document to User model
  factory UserModel.fromMap(Map<String, dynamic> data, String userId) {
    return UserModel(
      userId: data['userId'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      registrationDate: data['registrationDate'].toDate(),
      dob: data['dob'].toDate(),
      gender: data['gender'],
      nic: data['nic'],
      drivingLicenseNo: data['drivingLicenseNo'],
      email: data['email'],
      contactNumber: data['contactNumber'],
      password: data['password'],
      addressLine1: data['addressLine1'],
      addressLine2: data['addressLine2'],
      addressLine3: data['addressLine3'],
      city: data['city'],
      province: data['province'],
      bloodType: data['bloodType'],
      //medicalReport: File(data['medicalReport']),
      healthConditions: data['healthConditions'],
      isActive: data['isActive'],
    );
  }

  // Convert User model to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'dob': Timestamp.fromDate(DateTime(dob.year, dob.month, dob.day)),
      'gender': gender,
      'nic': nic,
      'drivingLicenseNo': drivingLicenseNo,
      'email': email,
      'contactNumber': contactNumber,
      'password': password,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'addressLine3': addressLine3,
      'city': city,
      'province': province,
      'bloodType': bloodType,
      //'medicalReport': medicalReport.path,
      'healthConditions': healthConditions,
      'isActive': isActive,
      'registrationDate': Timestamp.fromDate(registrationDate),
    };
  }
}
