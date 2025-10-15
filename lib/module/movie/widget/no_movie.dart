import 'package:flutter/material.dart';

class NoMovie extends StatelessWidget {
  const NoMovie({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No movies found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first movie using the + button',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
