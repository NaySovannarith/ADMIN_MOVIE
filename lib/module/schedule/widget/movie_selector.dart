import 'package:flutter/material.dart';
import 'package:admin_panel/data/model/movie.dart';

class MovieSelector extends StatelessWidget {
  final List<Movie> movies;
  final Movie? selectedMovie;
  final ValueChanged<Movie?> onChanged;

  const MovieSelector({
    super.key,
    required this.movies,
    required this.selectedMovie,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2d2d2d),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButton<Movie>(
          value: selectedMovie,
          items:
              movies.map((movie) {
                return DropdownMenuItem<Movie>(
                  value: movie,
                  child: Text(
                    movie.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
          onChanged: onChanged,
          isExpanded: true,
          dropdownColor: const Color(0xFF2d2d2d),
          underline: Container(height: 1, color: Colors.white30),
        ),
      ),
    );
  }
}
