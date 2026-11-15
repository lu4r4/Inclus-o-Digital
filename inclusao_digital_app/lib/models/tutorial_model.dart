class Tutorial {
  final int id;
  final String title;
  final String description;

  Tutorial({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
}
