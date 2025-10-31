import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  final String description;
  final int points;
  final bool completed;
  final String type; // 'daily' or 'weekly'

  const ChallengeCard({
    super.key,
    required this.description,
    required this.points,
    required this.completed,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final color = completed
        ? Colors.greenAccent
        : type == 'daily'
            ? Colors.blueAccent
            : Colors.yellowAccent;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '+$points pts',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
