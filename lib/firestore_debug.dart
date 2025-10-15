import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDebugScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Debug')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Firestore Connection Test:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'This screen will attempt to write a document to a "test_connection" collection to verify Firestore is working correctly.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _testConnection(context),
              child: const Text('Test Firestore Connection'),
            ),
          ],
        ),
      ),
    );
  }

  void _testConnection(BuildContext context) async {
    try {
      // Try to write a test document
      await _firestore.collection('test_connection').add({
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'Firestore is connected!',
      });

      // If the write succeeds, show a success message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Firestore connection successful!')),
      );
    } catch (e) {
      // If there's an error, show an error message.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Firestore error: $e')));
    }
  }
}
