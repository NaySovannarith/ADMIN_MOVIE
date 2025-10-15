import 'package:admin_panel/data/model/movie.dart';
import 'package:admin_panel/data/service/movie_service.dart';
import 'package:admin_panel/module/movie/widget/add_dialog.dart';
import 'package:admin_panel/module/movie/widget/delete_dialog.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final Movie movie;

  const DetailPage({super.key, required this.movie});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 24, 24),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          widget.movie.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 64, 1, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Hero(
              tag: widget.movie.posterUrl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.movie.posterUrl,
                  width: 350,
                  height: 500,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 40),

            // Details
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildDetailBox("Title", widget.movie.title),
                  buildDetailBox("Description", widget.movie.description),
                  buildDetailBox("Release Date", widget.movie.releaseDate),
                  buildDetailBox("Rating", widget.movie.rating),
                  buildDetailBox("Duration", "${widget.movie.duration} min"),
                  buildDetailBox("Genres", widget.movie.genres.join(", ")),

                  const SizedBox(height: 30),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed:
                            () => showEditMovieDialog(widget.movie.id, {
                              'title': widget.movie.title,
                              'description': widget.movie.description,
                              'posterUrl': widget.movie.posterUrl,
                              'releaseDate': widget.movie.releaseDate,
                              'genres': widget.movie.genres,
                              'rating': widget.movie.rating,
                              'duration': widget.movie.duration,
                            }),
                        child: const Text("Edit"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed:
                            () => MovieDeleteService.confirmDelete(
                              context,
                              widget.movie.id,
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Future<void> showEditMovieDialog(
    String id,
    Map<String, dynamic> movie,
  ) async {
    showDialog(
      context: context,
      builder:
          (_) => MovieFormDialog(
            movie: movie,
            onSubmit: (data) => MovieService.updateMovie(id, data),
            title: 'Edit Movie',
          ),
    );
  }
}
