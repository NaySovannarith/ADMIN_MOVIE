import 'package:flutter/material.dart';

class MovieSearchBar extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const MovieSearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search movies...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: const Color.fromARGB(255, 57, 57, 57),
        ),
        onChanged: onSearch,
      ),
    );
  }
}
