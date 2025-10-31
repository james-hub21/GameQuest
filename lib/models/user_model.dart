class AppUser {
  final String id;
  final String displayName;
  final String email;
  final bool isAdmin;
  final int points;
  final List<String> badges;
  final bool secretReward;
  final DateTime? rewardClaimedAt;
  final String? profilePic;

  AppUser({
    required this.id,
    required this.displayName,
    required this.email,
    required this.isAdmin,
    required this.points,
    required this.badges,
    required this.secretReward,
    this.rewardClaimedAt,
    this.profilePic,
  });

  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      id: data['id'] ?? '',
      displayName: data['display_name'] ?? '',
      email: data['email'] ?? '',
      isAdmin: data['is_admin'] ?? false,
      points: data['points'] ?? 0,
      badges: List<String>.from(data['badges'] ?? const <String>[]),
      secretReward: data['secret_reward'] ?? false,
      rewardClaimedAt: data['reward_claimed_at'] != null
          ? DateTime.tryParse(data['reward_claimed_at'].toString())
          : null,
      profilePic: data['profile_pic'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'display_name': displayName,
      'email': email,
      'is_admin': isAdmin,
      'points': points,
      'badges': badges,
      'secret_reward': secretReward,
      'reward_claimed_at': rewardClaimedAt?.toIso8601String(),
      'profile_pic': profilePic,
    };
  }
}
