import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool glow;
  final Color color;

  const BadgeIcon({
    super.key,
    required this.iconPath,
    required this.label,
    this.glow = false,
    this.color = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: glow
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.7),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 28,
            child: Image.asset(
              iconPath,
              width: 36,
              height: 36,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            shadows: [
              Shadow(
                blurRadius: 8,
                color: color.withOpacity(0.7),
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
