import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'services/auth_service.dart';
import 'services/supabase_service.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/admin_screen.dart';
import 'models/user_model.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/history_screen.dart';
import 'screens/add_item_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables with fallback
  String? supabaseUrl;
  String? supabaseAnonKey;
  
  try {
    await dotenv.load(fileName: '.env');
    supabaseUrl = dotenv.env['SUPABASE_URL'];
    supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
  } catch (_) {
    // Root .env not available, try assets
    try {
      await dotenv.load(fileName: 'assets/.env');
      supabaseUrl = dotenv.env['SUPABASE_URL'];
      supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
    } catch (_) {
      // If both fail, use hardcoded values for web (safe for public anon key)
      supabaseUrl = 'https://zomcaciegtyqpyrkxvob.supabase.co';
      supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpvbWNhY2llZ3R5cXB5cmt4dm9iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE5MDM4NzQsImV4cCI6MjA3NzQ3OTg3NH0.2sB7D3rJyqm9yBtka1pbi8VlfjxNgMukz_vQhk6DWCc';
    }
  }
  
  await Supabase.initialize(
    url: supabaseUrl!,
    anonKey: supabaseAnonKey!,
  );
  runApp(const GameQuestApp());
}

class GameQuestApp extends StatelessWidget {
  const GameQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SupabaseService()),
      ],
      child: MaterialApp(
        title: 'GameQuest',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF181A20),
          colorScheme: const ColorScheme.dark(
            primary: Colors.greenAccent,
            secondary: Colors.blueAccent,
            surface: Color(0xFF181A20),
          ),
          textTheme: ThemeData.dark().textTheme.apply(
                fontFamily: 'Orbitron',
              ),
        ),
        debugShowCheckedModeBanner: false,
        home: Consumer2<AuthService, SupabaseService>(
          builder: (context, auth, supabase, _) {
            if (auth.isInitializing) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            final currentUser = auth.user;
            if (currentUser == null) {
              return const LoginScreen();
            }
            return StreamBuilder<AppUser?>(
              stream: supabase.streamUser(currentUser.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                final appUser = snapshot.data;
                if (appUser == null) {
                  return const DashboardScreen();
                }
                if (appUser.isAdmin) {
                  return const AdminScreen();
                }
                return const DashboardScreen();
              },
            );
          },
        ),
        routes: {
          '/admin': (context) {
            final appUser = context.read<SupabaseService>()
                .streamUser(context.read<AuthService>().user!.id);
            return StreamBuilder<AppUser?>(
              stream: appUser,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data?.isAdmin == true) {
                  return const AdminScreen();
                }
                return const DashboardScreen();
              },
            );
          },
          '/leaderboard': (context) => const LeaderboardScreen(),
          '/history': (context) => const HistoryScreen(),
          '/add_item': (context) => const AddItemScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
