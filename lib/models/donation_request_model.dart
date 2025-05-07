import 'package:cloud_firestore/cloud_firestore.dart';

class BloodRequest {
  final String? requestId;
  final String patientName;
  final String requestedBy;
  final String requestBloodType;
  final String urgencyLevel;
  final String requestQuantity;
  final String province;
  final String city;
  final String hospitalName;
  final String contactNumber; 
  final DateTime createdAt;
  final String status;
  final List<Map<String, dynamic>>? confirmedDonors;

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
    required this.status,
    this.confirmedDonors,
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
      'status': status,
      'confirmedDonors': confirmedDonors!.map((item) => item).toList(),
    };
  }

  // Create a BloodRequest from a Firestore document snapshot
  factory BloodRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return BloodRequest(
      requestId: doc.id,
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
      status: data['status'] ?? 'pending',
      confirmedDonors: List<Map<String, dynamic>>.from(data['confirmedDonors']?.map((item) => item as Map<String, dynamic>) ?? []),
    );
  }
}
