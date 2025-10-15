import 'package:admin_panel/module/movie/detail/detail_page.dart';
import 'package:admin_panel/module/movie/widget/delete_dialog.dart';
import 'package:admin_panel/module/movie/widget/movie_search.dart';
import 'package:admin_panel/module/movie/widget/no_movie.dart';
import 'package:admin_panel/data/service/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/data/model/movie.dart';
import 'package:admin_panel/module/movie/widget/card_action.dart';
import 'package:admin_panel/module/movie/widget/add_dialog.dart';

class MoviePage extends StatefulWidget {
  @override
  MoviePageState createState() => MoviePageState();
}

class MoviePageState extends State<MoviePage> {
  final _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text(
          'MOVIE MANAGEMENT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationColor: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 55, 11, 2),
      ),
      body: Column(
        children: [
          MovieSearchBar(
            onSearch: (query) {
              setState(() => _searchQuery = query.toLowerCase());
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('movies').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const NoMovie();
                }
                //search engine
                final movies = MovieService.filterMovies(
                  snapshot.data!.docs,
                  _searchQuery,
                );
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final doc = movies[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final movie = Movie(
                      id: doc.id,
                      title: data['title'] ?? 'No Title',
                      description: data['description'] ?? '',
                      posterUrl: data['posterUrl'] ?? '',
                      releaseDate: data['releaseDate'] ?? '',
                      genres: List<String>.from(data['genres'] ?? []),
                      rating: data['rating'] ?? 'N/A',
                      duration: (data['duration'] ?? 0).toDouble(),
                    );

                    return GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(movie: movie),
                            ),
                          ),
                      child: MovieCardWithActions(
                        movie: movie,
                        onEdit: () => showEditMovieDialog(doc.id, data),
                        onDelete:
                            () => MovieDeleteService.confirmDelete(
                              context,
                              doc.id,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddMovieDialog,
        backgroundColor: const Color.fromARGB(255, 88, 3, 3),
        child: Icon(Icons.add, color: Colors.white, size: 28),
        tooltip: 'Add New Movie',
      ),
    );
  }

  // responsive
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  void showAddMovieDialog() {
    showDialog(
      context: context,
      builder:
          (_) => MovieFormDialog(
            onSubmit: (data) => MovieService.addMovie(data),
            title: 'Add New Movie',
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
