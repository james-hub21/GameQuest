import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
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
          appBar: AppBar(
            title: const Text('Profile'),
            backgroundColor: Colors.black,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blueAccent,
                  backgroundImage: appUser.profilePic != null
                      ? NetworkImage(appUser.profilePic!)
                      : null,
                  child: appUser.profilePic == null
                      ? const Icon(Icons.person, color: Colors.white, size: 40)
                      : null,
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
                Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Colors.greenAccent, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Total Points',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('${appUser.points}',
                            style: const TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 32)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Badges',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
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
                if (appUser.secretReward)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellowAccent
                              .withValues(alpha: 0.5),
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
              ],
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
    await supabaseService.uploadProfilePicture(userId);
    if (mounted) {
      setState(() {
        _isUploading = false;
      });
    }
  }
}
