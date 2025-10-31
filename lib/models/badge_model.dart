class Badge {
  final String id;
  final String name;
  final String iconPath;
  final String description;
  final int milestone;

  Badge({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.description,
    required this.milestone,
  });

  factory Badge.fromMap(Map<String, dynamic> data, String id) {
    return Badge(
      id: id,
      name: data['name'] ?? '',
      iconPath: data['iconPath'] ?? '',
      description: data['description'] ?? '',
      milestone: data['milestone'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconPath': iconPath,
      'description': description,
      'milestone': milestone,
    };
  }
}
