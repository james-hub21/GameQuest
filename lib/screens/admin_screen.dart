import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
import '../services/notification_service.dart';
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
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
            onPressed: () => auth.signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pending Submissions',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
            StreamBuilder<List<DropOff>>(
              stream: supabaseService.streamPendingDropOffs(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final dropOffs = snap.data!;
                if (dropOffs.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.greenAccent.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'No pending submissions.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return Column(
                  children: dropOffs
                      .map((d) => AdminDropOffCard(dropOff: d))
                      .toList(),
                );
              },
            ),
            ],
          ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: InkWell(
        onTap: dropOff.photoUrl != null
            ? () => _showPhoto(context, dropOff.photoUrl!)
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.greenAccent.withValues(alpha: 0.2),
                    ),
                    child: const Icon(
                      Icons.devices,
                      color: Colors.greenAccent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dropOff.itemName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'User: ${dropOff.userId.substring(0, 8)}...',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (dropOff.photoUrl != null) ...[
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.photo, color: Colors.blueAccent, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Tap to preview photo',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: NeonButton(
                  text: 'Confirm',
                  onPressed: () => AdminDropOffCard._handleConfirm(
                      context, supabaseService, dropOff),
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _handleConfirm(BuildContext context,
      SupabaseService supabaseService, DropOff dropOff) async {
    try {
      final points = _getPoints(dropOff.itemName);
      await supabaseService.confirmDropOff(dropOff: dropOff, points: points);
      if (!context.mounted) return;
      NotificationService.showSuccess(
        context,
        'Drop-off confirmed! User earned +$points points.',
      );
    } catch (e) {
      if (!context.mounted) return;
      NotificationService.showError(
        context,
        'Failed to confirm drop-off. Please try again.',
      );
    }
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
