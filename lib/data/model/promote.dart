class Promote {
  String id;
  String name;
  String imageUrl;
  String description;
  String chain;

  Promote({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.chain,
  });
  factory Promote.fromFirestore(Map<String, dynamic> map, String id) {
    return Promote(
      id: id,
      name: map["name"] ?? "Promotion",
      imageUrl: map["imageUrl"] ?? "https://via.placeholder.com/150",
      description: map["description"] ?? "No description available",
      chain: map["chain"] ?? "General",
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "imageUrl": imageUrl,
      "description": description,
      "chain": chain,
    };
  }
}
