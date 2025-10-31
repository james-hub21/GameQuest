class DropOff {
  final String id;
  final String userId;
  final String itemName;
  final String status;
  final String? confirmedBy;
  final DateTime? confirmedAt;
  final int pointsEarned;
  final String? verifiedLocation;

  DropOff({
    required this.id,
    required this.userId,
    required this.itemName,
    required this.status,
    this.confirmedBy,
    this.confirmedAt,
    required this.pointsEarned,
    this.verifiedLocation,
  });

  factory DropOff.fromMap(Map<String, dynamic> data, String id) {
    return DropOff(
      id: id,
      userId: data['userId'] ?? '',
      itemName: data['itemName'] ?? '',
      status: data['status'] ?? 'pending',
      confirmedBy: data['confirmedBy'],
      confirmedAt: data['confirmedAt']?.toDate(),
      pointsEarned: data['pointsEarned'] ?? 0,
      verifiedLocation: data['verifiedLocation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'itemName': itemName,
      'status': status,
      'confirmedBy': confirmedBy,
      'confirmedAt': confirmedAt,
      'pointsEarned': pointsEarned,
      'verifiedLocation': verifiedLocation,
    };
  }
}
