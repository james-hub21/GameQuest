import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/dropoff_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
        title: const Text('Submission History'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<List<DropOff>>(
        stream: firestore.streamDropOffs(user.uid),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final dropOffs = snap.data!;
          if (dropOffs.isEmpty) {
            return const Center(
              child: Text('No confirmed submissions yet.', style: TextStyle(color: Colors.white70)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dropOffs.length,
            itemBuilder: (context, i) {
              final d = dropOffs[i];
              if (d.status != 'confirmed') return const SizedBox.shrink();
              return Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.blueAccent, width: 2),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.devices, color: Colors.blueAccent),
                  title: Text(d.itemName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text('Points: ${d.pointsEarned} | ${d.verifiedLocation ?? "UIC"}', style: const TextStyle(color: Colors.white70)),
                  trailing: Text(
                    d.confirmedAt != null ?
                      '${d.confirmedAt!.month}/${d.confirmedAt!.day} ${d.confirmedAt!.hour}:${d.confirmedAt!.minute.toString().padLeft(2, '0')}' :
                      '',
                    style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
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
