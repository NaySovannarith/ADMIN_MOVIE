import 'package:cloud_firestore/cloud_firestore.dart';
import 'hall.dart';

class Theater {
  final String id;
  final String name;
  final String chain;
  final String coverUrl;
  final String address;
  final double latitude;
  final double longitude;
  final String mapUrl;
  final List<TheaterHall> halls;

  Theater({
    required this.id,
    required this.name,
    required this.chain,
    required this.coverUrl,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.mapUrl,
    required this.halls,
  });

  factory Theater.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // handle both String and double for lat/lon
    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return Theater(
      id: doc.id,
      name: data['name'] ?? '',
      chain: data['chain'] ?? '',
      coverUrl: data['coverUrl'] ?? data['imageUrl'] ?? '',
      address: data['address'] ?? '',
      latitude: parseDouble(data['latitude']),
      longitude: parseDouble(data['longitude']),
      mapUrl: data['mapUrl'] ?? '',
      halls:
          (data['halls'] as List<dynamic>? ?? [])
              .map((h) => TheaterHall.fromMap(h as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'chain': chain,
      'coverUrl': coverUrl,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'mapUrl': mapUrl,
      'halls': halls.map((h) => h.toMap()).toList(),
    };
  }
}
