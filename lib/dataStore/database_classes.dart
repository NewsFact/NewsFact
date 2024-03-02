class Feed {
  final int id;
  final String url;
  final String? name;
  final String? image;

  const Feed({
    required this.id,
    required this.url,
    this.name,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'Feed{id: $id, url: $url, name: $name, image: $image}';
  }
}