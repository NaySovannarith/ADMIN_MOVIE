class TheaterHall {
  String id;
  String name;

  TheaterHall({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory TheaterHall.fromMap(Map<String, dynamic> data) {
    return TheaterHall(id: data['id'] ?? '', name: data['name'] ?? '');
  }
}
