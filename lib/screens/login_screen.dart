import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/neon_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'GameQuest',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                    fontFamily: 'Orbitron',
                    shadows: [
                      Shadow(
                        blurRadius: 16,
                        color:
                            Colors.greenAccent.withValues(alpha: 0.7),
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.blueAccent),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onChanged: (val) => email = val,
                        validator: (val) => val != null && val.contains('@')
                            ? null
                            : 'Enter a valid email',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.blueAccent),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onChanged: (val) => password = val,
                        validator: (val) => val != null && val.length >= 6
                            ? null
                            : 'Min 6 chars',
                      ),
                      const SizedBox(height: 24),
                      NeonButton(
                        text: isLogin ? 'Login' : 'Register',
                        onPressed: _handleLoginOrRegister,
                        color: Colors.greenAccent,
                        isLoading: auth.isLoading,
                      ),
                      const SizedBox(height: 12),
                      NeonButton(
                        text: 'Sign in with Google',
                        onPressed: _handleGoogleSignIn,
                        color: Colors.blueAccent,
                        icon: Icons.g_mobiledata,
                        isLoading: auth.isLoading,
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin
                              ? "Don't have an account? Register"
                              : "Already have an account? Login",
                          style: const TextStyle(color: Colors.yellowAccent),
                        ),
                      ),
                      if (auth.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            auth.error!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLoginOrRegister() {
    _loginOrRegisterAsync();
  }

  Future<void> _loginOrRegisterAsync() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      if (isLogin) {
        await auth.signInWithEmail(email, password);
      } else {
        await auth.registerWithEmail(email, password);
      }
    }
  }

  void _handleGoogleSignIn() {
    _googleSignInAsync();
  }

  Future<void> _googleSignInAsync() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.signInWithGoogle();
  }
}
