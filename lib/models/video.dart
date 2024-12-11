class Video {
  final String id;
  final String title;
  final String thumbnail;
  final String channelTitle;
  final String description;
  final DateTime publishedAt;

  Video({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.channelTitle,
    required this.description,
    required this.publishedAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id']['videoId'] ?? json['id'],
      title: json['snippet']['title'],
      thumbnail: json['snippet']['thumbnails']['high']['url'],
      channelTitle: json['snippet']['channelTitle'],
      description: json['snippet']['description'],
      publishedAt: DateTime.parse(json['snippet']['publishedAt']),
    );
  }
}
