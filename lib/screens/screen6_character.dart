// ============================================================
// screens/screen6_character.dart
// ÉCRAN 6 : Choix du personnage (Garçon / Fille)
// ============================================================

import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../widgets/mewo_widgets.dart';
import '../models/player_data.dart';
import 'screen7_info.dart';

class Screen6Character extends StatelessWidget {
  const Screen6Character({super.key});

  void _selectCharacter(BuildContext context, String choice) {
    // On crée le PlayerData avec le choix du personnage
    final player = PlayerData(personnage: choice);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Screen7Info(player: player),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),

              // ---- Logo ----
              const MewoLogo(),

              const SizedBox(height: 12),

              // ---- Titre ----
              const Text(
                'Choisie ton personnage',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2),
                  ],
                ),
              ),

              const Spacer(),

              // ---- Les deux personnages côte à côte ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // --- GARÇON ---
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/perso_garcon.png',
                        height: 260,
                        errorBuilder: (_, __, ___) => _CharacterPlaceholder(
                          icon: Icons.man,
                          label: 'Garçon',
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      MewoButton(
                        label: 'Garçon',
                        fontSize: 18,
                        onTap: () => _selectCharacter(context, 'garcon'),
                      ),
                    ],
                  ),

                  // --- FILLE ---
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/perso_fille.png',
                        height: 260,
                        errorBuilder: (_, __, ___) => _CharacterPlaceholder(
                          icon: Icons.woman,
                          label: 'Fille',
                          color: Colors.pinkAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      MewoButton(
                        label: 'Fille',
                        fontSize: 18,
                        onTap: () => _selectCharacter(context, 'fille'),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _CharacterPlaceholder extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CharacterPlaceholder({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 220,
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: color),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
