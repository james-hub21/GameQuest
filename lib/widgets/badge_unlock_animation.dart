import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BadgeUnlockAnimation extends StatelessWidget {
  final String badgeIconPath;
  final String badgeName;

  const BadgeUnlockAnimation({
    super.key,
    required this.badgeIconPath,
    required this.badgeName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/animations/badge_unlock.json',
              width: 120, repeat: false),
          const SizedBox(height: 12),
          Image.asset(badgeIconPath, width: 48, height: 48),
          const SizedBox(height: 8),
          Text(
            'Badge Unlocked: $badgeName',
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: Colors.blueAccent,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
