import '../models/dropoff_model.dart';
import '../services/firestore_service.dart';
import 'package:flutter/material.dart';

Future<void> _handleConfirm(BuildContext context, FirestoreService firestore, DropOff dropOff) async {
  final points = _getPoints(dropOff.itemName);
  await firestore.updateDropOff(dropOff.id, {
    'status': 'confirmed',
    'confirmedBy': 'admin',
    'confirmedAt': DateTime.now(),
    'pointsEarned': points,
  });
  // Optionally update user points, badges, etc. via Cloud Function
}

int _getPoints(String itemName) {
  switch (itemName.toLowerCase()) {
    case 'phone': return 10;
    case 'laptop': return 15;
    case 'charger': return 5;
    case 'battery': return 8;
    case 'tablet': return 12;
    case 'earphones':
    case 'headphones': return 6;
    case 'usb':
    case 'flash drive': return 4;
    case 'power bank': return 7;
    case 'mouse':
    case 'keyboard': return 5;
    default: return 5;
  }
}