class Challenge {
  final String id;
  final String type; // daily or weekly
  final String description;
  final int points;
  final List<String> completedBy;

  Challenge({
    required this.id,
    required this.type,
    required this.description,
    required this.points,
    required this.completedBy,
  });

  factory Challenge.fromMap(Map<String, dynamic> data, String id) {
    return Challenge(
      id: id,
      type: data['type'] ?? 'daily',
      description: data['description'] ?? '',
      points: data['points'] ?? 0,
      completedBy: List<String>.from(data['completedBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'description': description,
      'points': points,
      'completedBy': completedBy,
    };
  }
}
