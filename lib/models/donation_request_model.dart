import 'package:cloud_firestore/cloud_firestore.dart';

class BloodRequest {
  String? requestId;
  String patientName;
  String requestedBy;
  String requestBloodType;
  String urgencyLevel;
  String requestQuantity;
  String province;
  String city;
  String hospitalName;
  String contactNumber; 
  DateTime createdAt;

  BloodRequest({
    this.requestId,
    required this.patientName,
    required this.requestedBy,
    required this.requestBloodType,
    required this.urgencyLevel,
    required this.requestQuantity,
    required this.province,
    required this.city,
    required this.hospitalName,
    required this.contactNumber,
    required this.createdAt,
  });

  // Convert a BloodRequest to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'patientName': patientName,
      'requestedBy': requestedBy,
      'requestBloodType': requestBloodType,
      'urgencyLevel': urgencyLevel,
      'requestQuantity': requestQuantity,
      'province': province,
      'city': city,
      'hospitalName': hospitalName,
      'contactNumber': contactNumber,
      'createdAt': createdAt,
    };
  }

  // Create a BloodRequest from a Firestore document snapshot
  factory BloodRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return BloodRequest(
      patientName: data['patientName'] ?? '',
      requestedBy: data['requestedBy'] ?? '',
      requestBloodType: data['requestBloodType'] ?? '',
      urgencyLevel: data['urgencyLevel'] ?? '',
      requestQuantity: data['requestQuantity'] ?? '',
      province: data['province'] ?? '',
      city: data['city'] ?? '',
      hospitalName: data['hospitalName'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
