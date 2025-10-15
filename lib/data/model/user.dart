import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String id; // Changed from int to String for Firestore
  String fullName;
  String email;
  String? phoneNumber;
  String? dateOfBirth;
  DateTime? createdAt;

  MyUser({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore document
  factory MyUser.fromFirestore(DocumentSnapshot doc) {
    final user = doc.data() as Map<String, dynamic>;
    return MyUser(
      id: doc.id, // Firestore document ID
      fullName: user['fullName'] ?? '',
      email: user['email'] ?? '',
      phoneNumber: user['phoneNumber'],
      dateOfBirth: user['dateOfBirth'],
      createdAt: user['createdAt']?.toDate(),
    );
  }
}
