class ChannelModel {
  final String id;
  final String name;
  final String tag;
  final String color;
  final String viewers;
  final String quality;
  final String? streamUrl;
  final String? backupUrl;
  final String? userAgent;
  final Map<String, String>? headers;

  String get category => tag;

  const ChannelModel({
    required this.id,
    required this.name,
    required this.tag,
    required this.color,
    required this.viewers,
    required this.quality,
    this.streamUrl,
    this.backupUrl,
    this.userAgent,
    this.headers,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id_live'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      tag: json['name_topic'] ?? json['tag'] ?? 'رياضة',
      color: json['color'] ?? '#372074',
      viewers: json['viewers'] ?? '40K',
      quality: json['quality'] ?? 'FHD',
      streamUrl: json['url'],
      backupUrl: json['backup'],
      userAgent: json['agent'],
    );
  }
}

class ChannelCategory {
  final String id;
  final String name;
  final String? imageUrl;

  const ChannelCategory({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory ChannelCategory.fromJson(Map<String, dynamic> json) {
    return ChannelCategory(
      id: json['id_topic'] ?? json['id'] ?? '',
      name: json['name_topic'] ?? json['name'] ?? '',
      imageUrl: json['img_url_topic'] ?? json['imageUrl'],
    );
  }
}
