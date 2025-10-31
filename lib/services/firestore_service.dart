import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/dropoff_model.dart';
import '../models/challenge_model.dart';

class FirestoreService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<AppUser?> streamUser(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((snap) {
      if (!snap.exists) return null;
      return AppUser.fromMap(snap.data()!, snap.id);
    });
  }

  Stream<List<DropOff>> streamDropOffs(String userId) {
    return _db.collection('dropOffs').where('userId', isEqualTo: userId).snapshots().map((snap) =>
      snap.docs.map((doc) => DropOff.fromMap(doc.data(), doc.id)).toList()
    );
  }

  Stream<List<Challenge>> streamChallenges() {
    return _db.collection('challenges').snapshots().map((snap) =>
      snap.docs.map((doc) => Challenge.fromMap(doc.data(), doc.id)).toList()
    );
  }

  Future<void> addDropOff(DropOff dropOff) async {
    await _db.collection('dropOffs').add(dropOff.toMap());
  }

  Future<void> updateDropOff(String id, Map<String, dynamic> data) async {
    await _db.collection('dropOffs').doc(id).update(data);
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).update(data);
  }

  Stream<List<DropOff>> streamPendingDropOffs() {
    return _db.collection('dropOffs').where('status', isEqualTo: 'pending').snapshots().map((snap) =>
      snap.docs.map((doc) => DropOff.fromMap(doc.data(), doc.id)).toList()
    );
  }

  Stream<List<AppUser>> streamLeaderboard() {
    return _db.collection('users').orderBy('totalPoints', descending: true).limit(10).snapshots().map((snap) =>
      snap.docs.map((doc) => AppUser.fromMap(doc.data(), doc.id)).toList()
    );
  }
}
