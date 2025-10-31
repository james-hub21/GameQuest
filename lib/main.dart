import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'models/user_model.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/history_screen.dart';
import 'screens/add_item_screen.dart';
import 'screens/profile_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const GameQuestApp());
  } catch (e, stack) {
    // Print errors to browser console for debugging
    // ignore: avoid_print
    print('Firebase initialization error: $e');
    // ignore: avoid_print
    print(stack);
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Failed to initialize Firebase. See browser console for details.',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }
}

class GameQuestApp extends StatelessWidget {
  const GameQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FirestoreService()),
      ],
      child: MaterialApp(
        title: 'GameQuest',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF181A20),
          colorScheme: ColorScheme.dark(
            primary: Colors.greenAccent,
            secondary: Colors.blueAccent,
            background: const Color(0xFF181A20),
          ),
          textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'Orbitron',
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData) {
              return const DashboardScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
        routes: {
          '/admin': (context) => const AdminScreen(),
          '/leaderboard': (context) => const LeaderboardScreen(),
          '/history': (context) => const HistoryScreen(),
          '/add_item': (context) => const AddItemScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
