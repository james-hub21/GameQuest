import 'package:flutter/material.dart';

class SecretRewardWidget extends StatelessWidget {
  final bool unlocked;
  final String? claimedAt;

  const SecretRewardWidget({
    super.key,
    required this.unlocked,
    this.claimedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.yellowAccent.withValues(alpha: 0.5),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/icons/secret_reward.png', width: 36, height: 36),
          const SizedBox(width: 12),
          Text(
            unlocked ? 'Secret Reward Unlocked!' : 'Secret Reward Locked',
            style: const TextStyle(
              color: Colors.yellowAccent,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: Colors.yellowAccent,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
          if (unlocked && claimedAt != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '($claimedAt)',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
