class AppUser {
  final String userId;
  final String name;
  final String email;
  final bool isAdmin;
  final int totalPoints;
  final List<String> badges;
  final bool secretReward;
  final DateTime? rewardClaimedAt;
  final String? profilePic;

  AppUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.totalPoints,
    required this.badges,
    required this.secretReward,
    this.rewardClaimedAt,
    this.profilePic,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String id) {
    return AppUser(
      userId: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
      totalPoints: data['totalPoints'] ?? 0,
      badges: List<String>.from(data['badges'] ?? []),
      secretReward: data['secretReward'] ?? false,
      rewardClaimedAt: data['rewardClaimedAt']?.toDate(),
      profilePic: data['profilePic'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
      'totalPoints': totalPoints,
      'badges': badges,
      'secretReward': secretReward,
      'rewardClaimedAt': rewardClaimedAt,
      'profilePic': profilePic,
    };
  }
}
