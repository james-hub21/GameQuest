import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
import '../models/dropoff_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final supabaseService = Provider.of<SupabaseService>(context);
    final user = auth.user;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        title: const Text(
          'Submission History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<List<DropOff>>(
        stream: supabaseService.streamDropOffs(user.id),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final dropOffs = snap.data!;
          if (dropOffs.isEmpty) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.blueAccent.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, color: Colors.white70, size: 48),
                    SizedBox(height: 12),
                    Text(
                      'No confirmed submissions yet.',
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
          final pending = dropOffs
              .where((d) => d.status == 'pending')
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          final confirmed = dropOffs
              .where((d) => d.status == 'confirmed')
              .toList()
            ..sort((a, b) => (b.confirmedAt ?? b.createdAt)
                .compareTo(a.confirmedAt ?? a.createdAt));

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              if (pending.isNotEmpty) ...[
                const Text(
                  'Pending',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                ...pending.map(
                  (d) => _HistoryCard(
                    dropOff: d,
                    borderColor: Colors.orangeAccent,
                    location: d.verifiedLocation ??
                        'Father Selga St., Davao City, Davao del Sur',
                    statusText: 'Pending',
                    statusColor: Colors.orangeAccent,
                    timestamp: d.createdAt,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const Text(
                'Confirmed',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              ...confirmed.map(
                (d) => _HistoryCard(
                  dropOff: d,
                  borderColor: Colors.blueAccent,
                  location: d.verifiedLocation ??
                      'Father Selga St., Davao City, Davao del Sur',
                  statusText: 'Confirmed',
                  statusColor: Colors.greenAccent,
                  timestamp: d.confirmedAt ?? d.createdAt,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final DropOff dropOff;
  final Color borderColor;
  final String location;
  final String statusText;
  final Color statusColor;
  final DateTime timestamp;

  const _HistoryCard({
    required this.dropOff,
    required this.borderColor,
    required this.location,
    required this.statusText,
    required this.statusColor,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
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
              child: Icon(
                Icons.devices,
                color: borderColor,
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
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Points: ${dropOff.pointsEarned} | $location',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${timestamp.month}/${timestamp.day}',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
