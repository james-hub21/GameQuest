class DropOff {
  final String id;
  final String userId;
  final String itemName;
  final String status;
  final String? confirmedBy;
  final DateTime? confirmedAt;
  final int pointsEarned;
  final String? verifiedLocation;
  final DateTime createdAt;
  final String? photoUrl;

  DropOff({
    required this.id,
    required this.userId,
    required this.itemName,
    required this.status,
    this.confirmedBy,
    this.confirmedAt,
    required this.pointsEarned,
    this.verifiedLocation,
    required this.createdAt,
    this.photoUrl,
  });

  factory DropOff.fromMap(Map<String, dynamic> data) {
    return DropOff(
      id: data['id']?.toString() ?? '',
      userId: data['user_id']?.toString() ?? '',
      itemName: data['item_name'] ?? '',
      status: data['status'] ?? 'pending',
      confirmedBy: data['confirmed_by'] as String?,
      confirmedAt: data['confirmed_at'] != null
          ? DateTime.tryParse(data['confirmed_at'].toString())
          : null,
      pointsEarned: data['points_earned'] ?? 0,
      verifiedLocation: data['verified_location'] as String?,
      createdAt:
          DateTime.tryParse(data['created_at'].toString()) ?? DateTime.now(),
      photoUrl: data['photo_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'item_name': itemName,
      'status': status,
      'confirmed_by': confirmedBy,
      'confirmed_at': confirmedAt?.toIso8601String(),
      'points_earned': pointsEarned,
      'verified_location': verifiedLocation,
      'created_at': createdAt.toIso8601String(),
      'photo_url': photoUrl,
    };
  }
}
