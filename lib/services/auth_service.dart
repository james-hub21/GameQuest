import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    error = null;
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
      error = _getUserFriendlyError(e.message);
    } catch (e) {
      error = 'An unexpected error occurred. Please try again.';
      debugPrint('Sign in error: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> registerWithEmail(String email, String password) async {
    isLoading = true;
    error = null;
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
      error = _getUserFriendlyError(e.message);
    } catch (e) {
      error = 'An unexpected error occurred. Please try again.';
      debugPrint('Registration error: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      if (kIsWeb) {
        // For web, use redirect
        await _supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: '${Uri.base.origin}/auth/callback',
        );
      } else {
        // For mobile, use launch URL
        await _supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: Platform.isAndroid
              ? 'com.example.gamequest://login-callback'
              : 'com.example.gamequest://login-callback',
        );
      }
      // Note: For OAuth, the actual authentication happens via redirect/callback
      // The user will be redirected to Google, then back to the app
      error = null;
    } on AuthException catch (e) {
      error = _getUserFriendlyError(e.message);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = 'Failed to sign in with Google. Please try again.';
      debugPrint('Google sign in error: $e');
      isLoading = false;
      notifyListeners();
    }
  }

  // Test user authentication for development
  Future<void> signInAsTestUser() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      // Try to sign in with test credentials
      // You can set these in your .env file or Supabase dashboard
      // Default: test@gamequest.app / test123456
      final testEmail = dotenv.env['TEST_USER_EMAIL'] ?? 'test@gamequest.app';
      final testPassword = dotenv.env['TEST_USER_PASSWORD'] ?? 'test123456';
      
      try {
        final response = await _supabase.auth.signInWithPassword(
          email: testEmail,
          password: testPassword,
        );
        final signedInUser = response.user ?? _supabase.auth.currentUser;
        if (signedInUser != null) {
          await _ensureUserRecord(signedInUser);
        }
        error = null;
      } catch (e) {
        // If test user doesn't exist, create it
        final registerResponse = await _supabase.auth.signUp(
          email: testEmail,
          password: testPassword,
        );
        final newUser = registerResponse.user ?? _supabase.auth.currentUser;
        if (newUser != null) {
          await _ensureUserRecord(newUser, displayName: 'Test User');
        }
        error = null;
      }
    } catch (e) {
      error = 'Failed to sign in as test user. Please try regular login.';
      debugPrint('Test user sign in error: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      user = null;
      error = null;
      notifyListeners();
    } catch (e) {
      error = 'Failed to sign out. Please try again.';
      debugPrint('Sign out error: $e');
      notifyListeners();
    }
  }

  Future<void> _ensureUserRecord(User supabaseUser,
      {String? displayName}) async {
    try {
      final email = supabaseUser.email ?? '';
      final userMetadata = supabaseUser.userMetadata;
      final fullName = userMetadata?['full_name'] as String?;
      final googleName = userMetadata?['name'] as String?;
      
      await _supabase.from('users').upsert({
        'id': supabaseUser.id,
        'email': email,
        'display_name': displayName ?? 
                       fullName ?? 
                       googleName ?? 
                       email.split('@').first,
      }, onConflict: 'id');
    } catch (e) {
      debugPrint('Error ensuring user record: $e');
      // Don't throw - user record creation is not critical for auth flow
    }
  }

  String _getUserFriendlyError(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'Invalid email or password. Please check your credentials.';
    } else if (message.contains('User already registered')) {
      return 'An account with this email already exists. Please sign in instead.';
    } else if (message.contains('Password')) {
      return 'Password is too weak. Please use a stronger password.';
    } else if (message.contains('Email')) {
      return 'Please enter a valid email address.';
    } else if (message.contains('network') || message.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    }
    return message;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
