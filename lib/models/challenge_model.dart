class Challenge {
  final String id;
  final String title;
  final String description;
  final int points;
  final String type; // daily or weekly
  final bool isActive;
  final List<String> completedBy;
  final DateTime createdAt;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.type,
    required this.isActive,
    required this.completedBy,
    required this.createdAt,
  });

  factory Challenge.fromMap(Map<String, dynamic> data) {
    return Challenge(
      id: data['id']?.toString() ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      points: data['points'] ?? 0,
      type: data['type'] ?? 'daily',
      isActive: data['is_active'] ?? true,
      completedBy: List<String>.from(data['completed_by'] ?? const <String>[]),
      createdAt:
          DateTime.tryParse(data['created_at'].toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'type': type,
      'is_active': isActive,
      'completed_by': completedBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
