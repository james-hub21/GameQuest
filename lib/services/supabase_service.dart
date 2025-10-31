import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import '../models/dropoff_model.dart';
import '../models/challenge_model.dart';

class SupabaseService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<AppUser?> streamUser(String userId) {
    return _supabase
        .from('users')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((event) => event.isEmpty ? null : AppUser.fromMap(event.first));
  }

  Stream<List<DropOff>> streamDropOffs(String userId) {
    return _supabase
        .from('drop_offs')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((event) {
          final list = event.map(DropOff.fromMap).toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  Stream<List<Challenge>> streamChallenges() {
    return _supabase
        .from('challenges')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .map((event) {
          final list = event.map(Challenge.fromMap).toList();
          list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          return list;
        });
  }

  Future<void> addDropOff({
    required String userId,
    required String itemName,
    String? verifiedLocation,
    String? photoUrl,
  }) async {
    await _supabase.from('drop_offs').insert({
      'user_id': userId,
      'item_name': itemName,
      'status': 'pending',
      'verified_location': verifiedLocation,
      'photo_url': photoUrl,
    });
  }

  Future<void> updateDropOff(String id, Map<String, dynamic> data) async {
    await _supabase.from('drop_offs').update(data).eq('id', id);
  }

  Future<void> confirmDropOff({
    required DropOff dropOff,
    required int points,
    String confirmedBy = 'admin',
  }) async {
    final now = DateTime.now().toIso8601String();
    await updateDropOff(dropOff.id, {
      'status': 'confirmed',
      'confirmed_by': confirmedBy,
      'confirmed_at': now,
      'points_earned': points,
    });
    try {
      await _supabase.functions.invoke('update_badges', body: {
        'user_id': dropOff.userId,
        'points_awarded': points,
        'drop_off_id': dropOff.id,
      });
    } catch (e) {
      debugPrint('Failed to invoke update_badges function: $e');
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _supabase.from('users').update(data).eq('id', userId);
  }

  Stream<List<DropOff>> streamPendingDropOffs() {
    return _supabase
        .from('drop_offs')
        .stream(primaryKey: ['id'])
        .eq('status', 'pending')
        .map((event) {
          final list = event.map(DropOff.fromMap).toList();
          list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          return list;
        });
  }

  Stream<List<AppUser>> streamLeaderboard({int limit = 10}) {
    return _supabase
        .from('leaderboard')
        .stream(primaryKey: ['id'])
        .limit(limit)
        .map((event) {
          final list = event.map(AppUser.fromMap).toList();
          list.sort((a, b) => b.points.compareTo(a.points));
          return list;
        });
  }

  Future<void> completeChallenge(String challengeId, String userId) async {
    await _supabase.rpc('complete_challenge', params: {
      'challenge_id_input': challengeId,
      'user_id_input': userId,
    });
  }

  Future<String?> uploadBytes({
    required String bucket,
    required String path,
    required List<int> bytes,
    String? fileName,
    String? mimeType,
  }) async {
    final resolvedMime = mimeType ?? lookupMimeType('', headerBytes: bytes);
    final resolvedName = fileName ?? '${DateTime.now().millisecondsSinceEpoch}';
    final storagePath = p.posix.join(path, resolvedName);
    await _supabase.storage.from(bucket).uploadBinary(
          storagePath,
          Uint8List.fromList(bytes),
          fileOptions: FileOptions(contentType: resolvedMime),
        );
    return getPublicUrl(bucket: bucket, path: storagePath);
  }

  Future<String?> pickAndUpload(
      {required String bucket, required String path}) async {
    final result = await FilePicker.platform
        .pickFiles(withData: true, allowMultiple: false);
    if (result == null || result.files.isEmpty) {
      return null;
    }
    final pickedFile = result.files.single;
    final bytes = pickedFile.bytes;
    if (bytes == null) {
      return null;
    }
    final extension =
        pickedFile.extension != null && pickedFile.extension!.isNotEmpty
            ? '.${pickedFile.extension}'
            : '';
    final generatedName = pickedFile.name.isNotEmpty
        ? pickedFile.name
        : 'upload-${DateTime.now().millisecondsSinceEpoch}$extension';
    final mimeType = lookupMimeType(generatedName, headerBytes: bytes);
    return uploadBytes(
      bucket: bucket,
      path: path,
      bytes: bytes,
      fileName: generatedName,
      mimeType: mimeType,
    );
  }

  String getPublicUrl({required String bucket, required String path}) {
    return _supabase.storage.from(bucket).getPublicUrl(path);
  }

  Future<String?> uploadProfilePicture(String userId) async {
    final url =
        await pickAndUpload(bucket: 'uploads', path: 'profiles/$userId');
    if (url != null) {
      await updateUser(userId, {'profile_pic': url});
    }
    return url;
  }
}
