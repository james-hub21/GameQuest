import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
import '../models/dropoff_model.dart';
import '../widgets/neon_button.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final supabaseService = Provider.of<SupabaseService>(context);
    final user = auth.user;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
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
            const Text('Pending Submissions',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            StreamBuilder<List<DropOff>>(
              stream: supabaseService.streamPendingDropOffs(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final dropOffs = snap.data!;
                if (dropOffs.isEmpty) {
                  return const Text('No pending submissions.',
                      style: TextStyle(color: Colors.white70));
                }
                return Column(
                  children: dropOffs
                      .map((d) => AdminDropOffCard(dropOff: d))
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            NeonButton(
              text: 'Leaderboard',
              onPressed: () => Navigator.pushNamed(context, '/leaderboard'),
              color: Colors.yellowAccent,
              icon: Icons.emoji_events,
            ),
          ],
        ),
      ),
    );
  }
}

class AdminDropOffCard extends StatelessWidget {
  final DropOff dropOff;
  const AdminDropOffCard({super.key, required this.dropOff});

  @override
  Widget build(BuildContext context) {
    final supabaseService =
        Provider.of<SupabaseService>(context, listen: false);
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.greenAccent, width: 2),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: dropOff.photoUrl != null
            ? () => _showPhoto(context, dropOff.photoUrl!)
            : null,
        leading: const Icon(Icons.devices, color: Colors.greenAccent),
        title: Text(dropOff.itemName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${dropOff.userId}',
                style: const TextStyle(color: Colors.white70)),
            if (dropOff.photoUrl != null)
              const Text('Tap to preview photo',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 12)),
          ],
        ),
        trailing: NeonButton(
          text: 'Confirm',
          onPressed: () => AdminDropOffCard._handleConfirm(
              context, supabaseService, dropOff),
          color: Colors.greenAccent,
        ),
      ),
    );
  }

  static Future<void> _handleConfirm(BuildContext context,
      SupabaseService supabaseService, DropOff dropOff) async {
    final points = _getPoints(dropOff.itemName);
    await supabaseService.confirmDropOff(dropOff: dropOff, points: points);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Drop-off confirmed (+$points pts)',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.greenAccent.withValues(alpha: 0.8),
      ),
    );
  }

  static int _getPoints(String itemName) {
    switch (itemName.toLowerCase()) {
      case 'phone':
        return 10;
      case 'laptop':
        return 15;
      case 'charger':
        return 5;
      case 'battery':
        return 8;
      case 'tablet':
        return 12;
      case 'earphones':
      case 'headphones':
        return 6;
      case 'usb':
      case 'flash drive':
        return 4;
      case 'power bank':
        return 7;
      case 'mouse':
      case 'keyboard':
        return 5;
      default:
        return 5;
    }
  }

  static void _showPhoto(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(url, fit: BoxFit.cover),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close',
                  style: TextStyle(color: Colors.greenAccent)),
            ),
          ],
        ),
      ),
    );
  }
}
