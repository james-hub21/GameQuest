import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
import '../models/user_model.dart';
import '../models/challenge_model.dart';
import '../widgets/neon_button.dart';
import '../widgets/badge_icon.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final supabaseService = Provider.of<SupabaseService>(context);
    final user = auth.user;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return StreamBuilder<AppUser?>(
      stream: supabaseService.streamUser(user.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: \\${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No user data found'));
        }
        final appUser = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                onPressed: () => auth.signOut(),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Points summary
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withValues(alpha: 0.4),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text('Total Points',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 8),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            appUser.points.toString(),
                            key: ValueKey(appUser.points),
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 16,
                                  color: Colors.greenAccent,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Badges
                const Text('Badges',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: appUser.badges.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) => BadgeIcon(
                      iconPath: 'assets/icons/${appUser.badges[i]}.png',
                      label: appUser.badges[i],
                      glow: true,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Secret Reward
                if (appUser.secretReward)
                  Center(
                    child: Container(
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
                          Image.asset('assets/icons/secret_reward.png',
                              width: 36, height: 36),
                          const SizedBox(width: 12),
                          const Text('Secret Reward Unlocked!',
                              style: TextStyle(
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
                              )),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                // Challenge Progress
                const Text('Challenges',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 8),
                StreamBuilder<List<Challenge>>(
                  stream: supabaseService.streamChallenges(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError) {
                      return Center(
                          child: Text('Error: ${snap.error}',
                              style: const TextStyle(color: Colors.red)));
                    }
                    if (!snap.hasData ||
                        snap.data == null ||
                        snap.data!.isEmpty) {
                      return const Center(child: Text('No challenges found'));
                    }
                    final challenges = snap.data!;
                    return Column(
                      children: challenges.map((c) {
                        final completed = c.completedBy.contains(appUser.id);
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: completed
                                  ? Colors.greenAccent
                                  : Colors.blueAccent,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (completed
                                        ? Colors.greenAccent
                                        : Colors.blueAccent)
                                    .withValues(alpha: 0.3),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                completed
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: completed
                                    ? Colors.greenAccent
                                    : Colors.blueAccent,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  c.description,
                                  style: TextStyle(
                                    color: completed
                                        ? Colors.greenAccent
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '+${c.points} pts',
                                style: TextStyle(
                                  color: completed
                                      ? Colors.greenAccent
                                      : Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Static Map
                const Text('UIC Drop-Off Location',
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 8),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.yellowAccent.withValues(alpha: 0.2),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/uic_map.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.map,
                                color: Colors.yellowAccent, size: 48),
                            SizedBox(height: 8),
                            Text(
                              'Map preview unavailable',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Navigation Buttons
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    NeonButton(
                      text: 'Add Item',
                      onPressed: () =>
                          Navigator.pushNamed(context, '/add_item'),
                      color: Colors.greenAccent,
                      icon: Icons.add,
                    ),
                    NeonButton(
                      text: 'History',
                      onPressed: () => Navigator.pushNamed(context, '/history'),
                      color: Colors.blueAccent,
                      icon: Icons.history,
                    ),
                    NeonButton(
                      text: 'Leaderboard',
                      onPressed: () =>
                          Navigator.pushNamed(context, '/leaderboard'),
                      color: Colors.yellowAccent,
                      icon: Icons.emoji_events,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
