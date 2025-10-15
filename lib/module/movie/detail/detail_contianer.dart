 import 'package:flutter/material.dart';

Widget buildDetailBox(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 40, 40, 40),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.white70),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }