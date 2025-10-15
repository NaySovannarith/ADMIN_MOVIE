import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieService {
  static final _firestore = FirebaseFirestore.instance;

  /// Filter movies by search query
  static List<QueryDocumentSnapshot> filterMovies(
    List<QueryDocumentSnapshot> docs,
    String query,
  ) {
    if (query.isEmpty) return docs;
    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final title = data['title']?.toString().toLowerCase() ?? '';
      return title.contains(query);
    }).toList();
  }
  // Add new movie
  static Future<void> addMovie(Map<String, dynamic> data) async {
    await _firestore.collection('movies').add(data);
  }
  // Update existing movie
  static Future<void> updateMovie(String id, Map<String, dynamic> data) async {
    await _firestore.collection('movies').doc(id).update(data);
  }
  //Delete movie with confirmation dialog
  static Future<void> confirmDelete(BuildContext context, String id) async {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this movie?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await _firestore.collection('movies').doc(id).delete();
                    _showSnackBar(
                      context,
                      'Movie deleted successfully!',
                      Colors.green,
                    );
                  } catch (e) {
                    _showSnackBar(
                      context,
                      'Error deleting movie: $e',
                      Colors.red,
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  static void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}

