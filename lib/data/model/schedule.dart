import 'package:cloud_firestore/cloud_firestore.dart';

class MovieSchedule {
  String id;
  String movieId;
  String movieTitle;
  String theaterId;
  String theaterName;
  String hallId;
  String hallName;
  DateTime date;
  String time;
  double ticketPrice;
  String posterUrl;

  MovieSchedule({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.theaterId,
    required this.theaterName,
    required this.hallId,
    required this.hallName,
    required this.date,
    required this.time,
    required this.ticketPrice,
    required this.posterUrl,
  });

  // Factory method for creating from Firestore document
  factory MovieSchedule.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return MovieSchedule(
      id: doc.id,
      movieId: map['movieId'] ?? '',
      movieTitle: map['movieTitle'] ?? '',
      theaterId: map['theaterId'] ?? '',
      theaterName: map['theaterName'] ?? '',
      hallId: map['hallId'] ?? '',
      hallName: map['hallName'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      time: map['time'] ?? '',    
      ticketPrice: (map['ticketPrice'] as num).toDouble(),
      posterUrl: map['posterUrl'] ??'',
    );
  }
  // Factory method for creating from simplified map (used in TheaterHall)
  factory MovieSchedule.fromSimplifiedMap(Map<String, dynamic> map) {
    return MovieSchedule(
      id: map['id'] ?? '',
      movieId: map['movieId'] ?? '',
      movieTitle: map['movieTitle'] ?? '',
      theaterId: map['theaterId'] ?? '',
      theaterName: map['theaterName'] ?? '',
      hallId: map['hallId'] ?? '',
      hallName: map['hallName'] ?? '',
      date:
          map['date'] is Timestamp
              ? (map['date'] as Timestamp).toDate()
              : DateTime.parse(map['date']),
      time: map['time'] ?? '',
      ticketPrice: (map['ticketPrice'] as num?)?.toDouble() ?? 0.0,
      posterUrl: map['posterUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movieId': movieId,
      'movieTitle': movieTitle,
      'theaterId': theaterId,
      'theaterName': theaterName,
      'hallId': hallId,
      'hallName': hallName,
      'date': Timestamp.fromDate(date),
      'time': time,
      'ticketPrice': ticketPrice,
      'posterUrl': posterUrl,
    };
  } 
  // Simplified version for storing in TheaterHall
  Map<String, dynamic> toSimplifiedMap() {
    return {
      'id': id,
      'movieId': movieId,
      'movieTitle': movieTitle,
      'date': Timestamp.fromDate(date),
      'time': time,
      'ticketPrice': ticketPrice,
      'posterUrl': posterUrl,
    };
  }
}
