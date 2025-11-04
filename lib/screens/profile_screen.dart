import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
import '../services/notification_service.dart';
import '../models/user_model.dart';
import '../widgets/badge_icon.dart';
import '../widgets/neon_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUploading = false;

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
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final appUser = snapshot.data!;
        return Scaffold(
          backgroundColor: const Color(0xFF181A20),
          appBar: AppBar(
            title: const Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            backgroundColor: Colors.black,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withValues(alpha: 0.5),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
                    backgroundImage: appUser.profilePic != null
                        ? NetworkImage(appUser.profilePic!)
                        : null,
                    child: appUser.profilePic == null
                        ? const Icon(Icons.person, color: Colors.blueAccent, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                NeonButton(
                  text: _isUploading ? 'Updating...' : 'Update Photo',
                  onPressed: _isUploading
                      ? null
                      : () => _handleUpdatePhoto(supabaseService, user.id),
                  color: Colors.blueAccent,
                  icon: Icons.upload,
                  isLoading: _isUploading,
                ),
                const SizedBox(height: 24),
                Text(appUser.displayName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22)),
                const SizedBox(height: 8),
                Text(appUser.email,
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 24),
                Container(
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${appUser.points}',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                          shadows: [
                            Shadow(
                              blurRadius: 20,
                              color: Colors.greenAccent,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Badges',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                appUser.badges.isEmpty
                    ? Container(
                        width: double.infinity,
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
                const SizedBox(height: 24),
                if (appUser.secretReward)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleUpdatePhoto(
      SupabaseService supabaseService, String userId) async {
    setState(() {
      _isUploading = true;
    });
    try {
      await supabaseService.uploadProfilePicture(userId);
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
        NotificationService.showSuccess(
          context,
          'Profile picture updated successfully!',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
        NotificationService.showError(
          context,
          'Failed to update profile picture. Please try again.',
        );
      }
    }
  }
}
