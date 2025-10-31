import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? user;
  bool isLoading = false;
  bool isInitializing = true;
  String? error;

  StreamSubscription<AuthState>? _authSubscription;

  AuthService() {
    user = _supabase.auth.currentUser;
    if (user != null) {
      isInitializing = false;
    }
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) async {
      user = data.session?.user;
      isInitializing = false;
      if (user != null) {
        await _ensureUserRecord(user!);
      }
      notifyListeners();
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await _supabase.auth
          .signInWithPassword(email: email, password: password);
      final signedInUser = response.user ?? _supabase.auth.currentUser;
      if (signedInUser != null) {
        await _ensureUserRecord(signedInUser);
      }
      error = null;
    } on AuthException catch (e) {
      error = e.message;
    } catch (e) {
      error = 'Unexpected error: $e';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> registerWithEmail(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final response =
          await _supabase.auth.signUp(email: email, password: password);
      final newUser = response.user ?? _supabase.auth.currentUser;
      if (newUser != null) {
        await _ensureUserRecord(newUser, displayName: email.split('@').first);
      }
      error = null;
    } on AuthException catch (e) {
      error = e.message;
    } catch (e) {
      error = 'Unexpected error: $e';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    isLoading = true;
    notifyListeners();
    try {
      await _supabase.auth.signInWithOAuth(OAuthProvider.google);
      error = null;
    } on AuthException catch (e) {
      error = e.message;
    } catch (e) {
      error = 'Unexpected error: $e';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    user = null;
    notifyListeners();
  }

  Future<void> _ensureUserRecord(User supabaseUser,
      {String? displayName}) async {
    final email = supabaseUser.email ?? '';
    await _supabase.from('users').upsert({
      'id': supabaseUser.id,
      'email': email,
      'display_name': displayName ?? email.split('@').first,
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
