import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/dropoff_model.dart';
import '../models/user_model.dart';
import '../widgets/neon_button.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final firestore = Provider.of<FirestoreService>(context);
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
              stream: firestore.streamPendingDropOffs(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final dropOffs = snap.data!;
                if (dropOffs.isEmpty) {
                  return const Text('No pending submissions.', style: TextStyle(color: Colors.white70));
                }
                return Column(
                  children: dropOffs.map((d) => AdminDropOffCard(dropOff: d)).toList(),
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
    final firestore = Provider.of<FirestoreService>(context, listen: false);
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.greenAccent, width: 2),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.devices, color: Colors.greenAccent),
        title: Text(dropOff.itemName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('User: ${dropOff.userId}', style: const TextStyle(color: Colors.white70)),
        trailing: NeonButton(
          text: 'Confirm',
          onPressed: () => AdminDropOffCard._handleConfirm(context, firestore, dropOff),
          color: Colors.greenAccent,
        ),
      ),
    );
  }

  static Future<void> _handleConfirm(BuildContext context, FirestoreService firestore, DropOff dropOff) async {
    final points = _getPoints(dropOff.itemName);
    await firestore.updateDropOff(dropOff.id, {
      'status': 'confirmed',
      'confirmedBy': 'admin',
      'confirmedAt': DateTime.now(),
      'pointsEarned': points,
    });
    // Optionally update user points, badges, etc. via Cloud Function
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
}
