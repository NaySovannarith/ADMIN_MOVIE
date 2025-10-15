import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  String id;
  String title;
  String description;
  String posterUrl;
  String releaseDate;
  List<String> genres;
  String rating;
  double duration;
  DateTime? createdAt;
  bool nowPlaying;
  bool comingSoon;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.releaseDate,
    required this.genres,
    required this.rating,
    this.duration = 0.0,
    this.createdAt,
    this.nowPlaying = false,
    this.comingSoon = false,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'posterUrl': posterUrl,
      'releaseDate': releaseDate,
      'genres': genres,
      'rating': rating,
      'duration': duration,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'nowPlaying': nowPlaying,
      'comingSoon': comingSoon,
    };
  }

  // Create from Firestore document
  factory Movie.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Movie(
      id: doc.id, // Firestore document ID
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      posterUrl: data['posterUrl'] ?? '',
      releaseDate: data['releaseDate'] ?? '',
      genres: List<String>.from(data['genres'] ?? []),
      rating: data['rating'] ?? '',
      //rating: List<String>.from(data['rating'] ?? []),
      duration: data['duration']?.toDouble() ?? 0.0,
      createdAt: data['createdAt']?.toDate(),
      nowPlaying: data['nowPlaying'] ?? false,
      comingSoon: data['comingSoon'] ?? false,
    );
  }
}
