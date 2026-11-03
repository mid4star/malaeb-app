class MovieModel {
  final String id;
  final String title;
  final String meta;
  final String imageUrl;
  final String category;
  final String rating;
  final String? streamUrl;

  const MovieModel({
    required this.id,
    required this.title,
    required this.meta,
    required this.imageUrl,
    required this.category,
    required this.rating,
    this.streamUrl,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      meta: json['meta'] ?? '',
      imageUrl: json['image'] ?? json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      rating: json['rating'] ?? '8.5',
      streamUrl: json['url'],
    );
  }
}
