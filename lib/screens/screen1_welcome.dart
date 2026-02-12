// ============================================================
// screens/screen1_welcome.dart — CORRIGÉ (responsive)
// ÉCRAN 1 : Page d'accueil avec bouton "BIENVENUE"
// ============================================================

import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../widgets/mewo_widgets.dart';
import 'screen2_presentation.dart';

class Screen1Welcome extends StatelessWidget {
  const Screen1Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: SizedBox(
            //   Force la largeur complète pour centrer correctement
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Centre tout
              children: [
                const SizedBox(height: 40),

                // ---- Logo centré en haut ----
                const MewoLogo(),

                // ---- Espace flexible (pousse le bouton en bas) ----
                const Spacer(),

                // ---- Sous-titre "Quiz Arena" ----
                const Text(
                  'QUIZ ARENA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                    shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
                  ),
                ),

                const SizedBox(height: 40),

                // ---- Bouton BIENVENUE centré ----
                MewoButton(
                  label: 'BIENVENUE',
                  fontSize: 26,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Screen2Presentation(pageIndex: 0),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}