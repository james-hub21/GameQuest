import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
import '../services/notification_service.dart';
import '../models/user_model.dart';
import '../models/challenge_model.dart';
import '../widgets/badge_icon.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const LatLng _uicCoordinates = LatLng(7.0699417, 125.6001476);
  static const String _uicLocationName =
      'University of the Immaculate Conception - Main Campus';
  static const String _uicAddress =
      'Father Selga St., Davao City, Davao del Sur';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final supabaseService = Provider.of<SupabaseService>(context);
    final user = auth.user;
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return StreamBuilder<AppUser?>(
      stream: supabaseService.streamUser(user.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('No user data found')),
          );
        }
        final appUser = snapshot.data!;
        return Scaffold(
          backgroundColor: const Color(0xFF181A20),
          appBar: AppBar(
            title: const Text(
              'Dashboard',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            backgroundColor: Colors.black,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                onPressed: () async {
                  await auth.signOut();
                  if (context.mounted) {
                    NotificationService.showInfo(
                      context,
                      'You have been signed out',
                    );
                  }
                },
                tooltip: 'Sign out',
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Points summary - Mobile optimized
                  Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.greenAccent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Total Points',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              appUser.points.toString(),
                              key: ValueKey(appUser.points),
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 20,
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
                  const SizedBox(height: 20),
                  // Badges - Mobile optimized
                  const Text(
                    'Badges',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  appUser.badges.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.blueAccent.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'No badges yet. Complete challenges to earn badges!',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 100,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: appUser.badges.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 16),
                            itemBuilder: (context, i) => BadgeIcon(
                              iconPath: 'assets/icons/${appUser.badges[i]}.png',
                              label: appUser.badges[i],
                              glow: true,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  // Secret Reward - Mobile optimized
                  if (appUser.secretReward)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.yellowAccent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellowAccent.withValues(alpha: 0.6),
                            blurRadius: 16,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/secret_reward.png',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 12),
                          const Flexible(
                            child: Text(
                              'Secret Reward Unlocked!',
                              style: TextStyle(
                                color: Colors.yellowAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                shadows: [
                                  Shadow(
                                    blurRadius: 8,
                                    color: Colors.yellowAccent,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (appUser.secretReward) const SizedBox(height: 0),
                  // Challenge Progress - Mobile optimized
                  const Text(
                    'Challenges',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
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
                        return InkWell(
                          onTap: completed
                              ? null
                              : () async {
                                  try {
                                    await supabaseService.completeChallenge(
                                      c.id,
                                      appUser.id,
                                    );
                                    if (context.mounted) {
                                      NotificationService.showSuccess(
                                        context,
                                        'Challenge completed! +${c.points} points earned!',
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      NotificationService.showError(
                                        context,
                                        'Failed to complete challenge. Please try again.',
                                      );
                                    }
                                  }
                                },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
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
                                      .withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  spreadRadius: 0.5,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: completed
                                        ? Colors.greenAccent.withValues(alpha: 0.2)
                                        : Colors.blueAccent.withValues(alpha: 0.2),
                                  ),
                                  child: Icon(
                                    completed
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: completed
                                        ? Colors.greenAccent
                                        : Colors.blueAccent,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.description,
                                        style: TextStyle(
                                          color: completed
                                              ? Colors.greenAccent.withValues(alpha: 0.9)
                                              : Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          height: 1.3,
                                        ),
                                      ),
                                      if (!completed) ...[
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Tap to complete',
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '+${c.points} pts',
                                      style: TextStyle(
                                        color: completed
                                            ? Colors.greenAccent
                                            : Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                  const SizedBox(height: 20),
                  // Interactive Map - Mobile optimized
                  const Text(
                    _uicLocationName,
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    _uicAddress,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.yellowAccent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellowAccent.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: FlutterMap(
                        options: const MapOptions(
                          initialCenter: _uicCoordinates,
                          initialZoom: 16.0,
                          minZoom: 13.0,
                          maxZoom: 18.0,
                          interactionOptions: InteractionOptions(
                            flags: InteractiveFlag.all,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.gamequest.app',
                            maxZoom: 19,
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _uicCoordinates,
                                width: 40,
                                height: 40,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.yellowAccent.withValues(alpha: 0.8),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.yellowAccent,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.yellowAccent.withValues(alpha: 0.6),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context,
                      icon: Icons.add_circle_outline,
                      label: 'Add Item',
                      color: Colors.greenAccent,
                      route: '/add_item',
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.history,
                      label: 'History',
                      color: Colors.blueAccent,
                      route: '/history',
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.emoji_events,
                      label: 'Leaderboard',
                      color: Colors.yellowAccent,
                      route: '/leaderboard',
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.person_outline,
                      label: 'Profile',
                      color: Colors.purpleAccent,
                      route: '/profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required String route,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

