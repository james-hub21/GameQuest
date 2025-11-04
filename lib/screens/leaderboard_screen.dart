import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/supabase_service.dart';
import '../models/user_model.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseService = Provider.of<SupabaseService>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<List<AppUser>>(
        stream: supabaseService.streamLeaderboard(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snap.data!;
          if (users.isEmpty) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.yellowAccent.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.emoji_events, color: Colors.white70, size: 48),
                    SizedBox(height: 12),
                    Text(
                      'No leaderboard data yet.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: users.length,
            itemBuilder: (context, i) {
              final user = users[i];
              final isTop = i == 0;
              final isSecond = i == 1;
              final isThird = i == 2;
              final borderColor = isTop
                  ? Colors.yellowAccent
                  : isSecond
                      ? Colors.blueAccent
                      : isThird
                          ? Colors.greenAccent
                          : Colors.white24;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: borderColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: borderColor.withValues(alpha: 0.2),
                        ),
                        child: Center(
                          child: Text(
                            '#${i + 1}',
                            style: TextStyle(
                              color: borderColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              shadows: [
                                Shadow(
                                  blurRadius: 8,
                                  color: borderColor,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.stars,
                                    color: Colors.yellowAccent, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  '${user.points} pts',
                                  style: const TextStyle(
                                    color: Colors.yellowAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                if (user.badges.isNotEmpty) ...[
                                  const SizedBox(width: 12),
                                  ...user.badges.take(3).map((b) => Padding(
                                        padding: const EdgeInsets.only(right: 4.0),
                                        child: Image.asset(
                                          'assets/icons/$b.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      )),
                                ],
                                if (user.secretReward) ...[
                                  const SizedBox(width: 8),
                                  Image.asset(
                                    'assets/icons/secret_reward.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
