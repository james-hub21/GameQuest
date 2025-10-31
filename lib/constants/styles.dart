import 'package:flutter/material.dart';

class AppStyles {
  static const Color background = Color(0xFF181A20);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonBlue = Color(0xFF00FFFF);
  static const Color neonYellow = Color(0xFFFFFF00);
  static const Color card = Color(0xFF23272F);
  static const Color accent = neonGreen;
  static const Color error = Colors.redAccent;

  static const TextStyle heading = TextStyle(
    color: neonGreen,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: 'Orbitron',
    shadows: [
      Shadow(blurRadius: 8, color: neonGreen, offset: Offset(0, 0)),
    ],
  );

  static const TextStyle subheading = TextStyle(
    color: neonBlue,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: 'Orbitron',
    shadows: [
      Shadow(blurRadius: 6, color: neonBlue, offset: Offset(0, 0)),
    ],
  );

  static const TextStyle body = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: 'Orbitron',
  );
}
