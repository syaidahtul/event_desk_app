class EventCategories {
  final int id;
  final String name;
  final String description;
  final double price;

  EventCategories({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory EventCategories.fromJson(Map<String, dynamic> json) {
    return EventCategories(
      id: json['id'],
      name: json['name'],
      description: json['description_en'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
    );
  }
}
