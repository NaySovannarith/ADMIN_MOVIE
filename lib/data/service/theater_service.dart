import 'package:admin_panel/data/model/theater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TheaterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all theaters
  Future<List<Theater>> getAllTheaters() async {
    try {
      final snapshot = await _firestore.collection('theaters').get();
      return snapshot.docs.map((doc) => Theater.fromDocument(doc)).toList();
    } catch (e) {
      print('Error getting all theaters: $e');
      throw Exception('Failed to load theaters');
    }
  }

  // Get theater by ID
  Future<Theater?> getTheaterById(String id) async {
    try {
      final doc = await _firestore.collection('theaters').doc(id).get();
      if (doc.exists) {
        return Theater.fromDocument(doc);
      }
      return null;
    } catch (e) {
      print('Error getting theater by ID: $e');
      throw Exception('Failed to load theater');
    }
  }

  // Stream of all theaters (for real-time updates)
  Stream<List<Theater>> streamAllTheaters() {
    return _firestore
        .collection('theaters')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Theater.fromDocument(doc)).toList(),
        );
  }

  // Update theater
  Future<void> updateTheater(Theater theater) async {
    try {
      await _firestore
          .collection('theaters')
          .doc(theater.id)
          .update(theater.toMap());
    } catch (e) {
      print('Error updating theater: $e');
      throw Exception('Failed to update theater');
    }
  }

  // Add new theater
  Future<void> addTheater(Theater theater) async {
    try {
      await _firestore.collection('theaters').add(theater.toMap());
    } catch (e) {
      print('Error adding theater: $e');
      throw Exception('Failed to add theater');
    }
  }

  //delete theater
  Future<void> deleteTheater(String id) async {
    try {
      await _firestore.collection('theaters').doc(id).delete();
    } catch (e) {
      print('Error deleting theater: $e');
      throw Exception('Failed to delete theater');
    }
  }
}
