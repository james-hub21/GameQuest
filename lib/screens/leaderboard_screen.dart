import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../widgets/badge_icon.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirestoreService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<List<AppUser>>(
        stream: firestore.streamLeaderboard(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snap.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, i) {
              final user = users[i];
              final isTop = i == 0;
              final isSecond = i == 1;
              final isThird = i == 2;
              return Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isTop
                        ? Colors.yellowAccent
                        : isSecond
                            ? Colors.blueAccent
                            : isThird
                                ? Colors.greenAccent
                                : Colors.white24,
                    width: 2,
                  ),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text(
                      '#${i + 1}',
                      style: TextStyle(
                        color: isTop
                            ? Colors.yellowAccent
                            : isSecond
                                ? Colors.blueAccent
                                : isThird
                                    ? Colors.greenAccent
                                    : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: isTop
                                ? Colors.yellowAccent
                                : isSecond
                                    ? Colors.blueAccent
                                    : isThird
                                        ? Colors.greenAccent
                                        : Colors.white24,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.stars, color: Colors.yellowAccent, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${user.totalPoints} pts',
                        style: const TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      if (user.badges.isNotEmpty)
                        Row(
                          children: user.badges
                              .map((b) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: BadgeIcon(
                                      iconPath: 'assets/icons/$b.png',
                                      label: '',
                                      glow: true,
                                      color: Colors.blueAccent,
                                    ),
                                  ))
                              .toList(),
                        ),
                      if (user.secretReward)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image.asset('assets/icons/secret_reward.png', width: 24, height: 24),
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
