import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieDeleteService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> confirmDelete(BuildContext context, String id) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
                _showSnackBar(context, 'Movie deleted successfully!', Colors.green);
              } catch (e) {
                _showSnackBar(context, 'Error deleting movie: $e', Colors.red);
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}
