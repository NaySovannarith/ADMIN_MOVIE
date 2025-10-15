import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/data/model/movie.dart';
import 'package:admin_panel/module/movie/widget/add_dialog.dart'; // for edit dialog

class DetailPageV2 extends StatefulWidget {
  final Movie movie;

  const DetailPageV2({super.key, required this.movie});

  @override
  State<DetailPageV2> createState() => _DetailPageV2State();
}

class _DetailPageV2State extends State<DetailPageV2> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 24, 24),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          movie.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 64, 1, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //poster
              Hero(
                tag: widget.movie.posterUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    movie.posterUrl,
                    width: 350,
                    height: 500,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 40),

              // Movie details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailBox("Title", widget.movie.title),
                    buildDetailBox("Description", widget.movie.description),
                    buildDetailBox("Release Date", widget.movie.releaseDate),
                    buildDetailBox("Rating", widget.movie.rating),
                    buildDetailBox("Duration", "${widget.movie.duration} min"),
                    buildDetailBox("Genres", widget.movie.genres.join(", ")),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _editMovie(context, movie),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                          ),
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _deleteMovie(context, movie.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                          ),
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  void _editMovie(BuildContext context, Movie movie) {
    showDialog(
      context: context,
      builder:
          (_) => MovieFormDialog(
            movie: {
              "title": movie.title,
              "description": movie.description,
              "posterUrl": movie.posterUrl,
              "releaseDate": movie.releaseDate,
              "rating": movie.rating,
              "duration": movie.duration,
              "genres": movie.genres,
            },
            onSubmit: (data) async {
              await _firestore.collection("movies").doc(movie.id).update(data);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Movie updated successfully"),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() {
                // Update UI immediately
                widget.movie.title = data["title"];
                widget.movie.description = data["description"];
                widget.movie.posterUrl = data["posterUrl"];
                widget.movie.releaseDate = data["releaseDate"];
                widget.movie.rating = data["rating"];
                widget.movie.duration = data["duration"];
                widget.movie.genres = List<String>.from(data["genres"]);
              });
            },
            title: "Edit Movie",
          ),
    );
  }

  Future<void> _deleteMovie(BuildContext context, String id) async {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text("Are you sure you want to delete this movie?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _firestore.collection("movies").doc(id).delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Movie deleted successfully"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.pop(context); // go back after delete
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
