// ============================================================
// screens/screen9_universe_intro.dart
// ÉCRAN 9 : Introduction à l'univers choisi
// Réutilisable pour les 5 univers (couleurs + textes changeants)
// ============================================================

import 'package:flutter/material.dart';
import '../widgets/futuristic_background.dart';
import '../models/player_data.dart';
import 'screen10_quiz.dart'; //  Écran 10 créé

// ----------------------------------------------------------------
// Configuration visuelle de chaque univers
// ----------------------------------------------------------------
const Map<String, _UniversConfig> _universConfigs = {
  'MEWO ANIMAL': _UniversConfig(
    displayName: 'MEWO\nANIMAL',
    primaryColor: Color(0xFF00E676),   // Vert nature
    secondaryColor: Color(0xFF76FF03),
    description:
        'Chaque question apparaîtra à l\'écran, et tu disposes de 10 secondes '
        'pour choisir la bonne réponse.\nLe chrono démarre immédiatement : '
        'sois rapide, précis et stratégique !',
  ),
  'MEWO JURIDIQUE': _UniversConfig(
    displayName: 'MEWO\nJURIDIQUE',
    primaryColor: Color(0xFFAA00FF),   // Violet justice
    secondaryColor: Color(0xFFE040FB),
    description:
        'Chaque question apparaîtra à l\'écran, et tu disposes de 10 secondes '
        'pour choisir la bonne réponse.\nLe chrono démarre immédiatement : '
        'sois rapide, précis et stratégique !',
  ),
  'MEWO INFORMATIQUE': _UniversConfig(
    displayName: 'MEWO\nINFORMATIQUE',
    primaryColor: Color(0xFF00E5FF),   // Cyan tech
    secondaryColor: Color(0xFFAA00FF), // Violet
    description:
        'Chaque question apparaîtra à l\'écran, et tu disposes de 10 secondes '
        'pour choisir la bonne réponse.\nLe chrono démarre immédiatement : '
        'sois rapide, précis et stratégique !',
  ),
  'MEWO SERVICE': _UniversConfig(
    displayName: 'MEWO\nSERVICE',
    primaryColor: Color(0xFF0091EA),   // Bleu service
    secondaryColor: Color(0xFF00B8D4),
    description:
        'Chaque question apparaîtra à l\'écran, et tu disposes de 10 secondes '
        'pour choisir la bonne réponse.\nLe chrono démarre immédiatement : '
        'sois rapide, précis et stratégique !',
  ),
  'MEWO SANTE': _UniversConfig(
    displayName: 'MEWO\nSANTÉ',
    primaryColor: Color(0xFF00E676),   // Vert santé
    secondaryColor: Color(0xFF1DE9B6),
    description:
        'Chaque question apparaîtra à l\'écran, et tu disposes de 10 secondes '
        'pour choisir la bonne réponse.\nLe chrono démarre immédiatement : '
        'sois rapide, précis et stratégique !',
  ),
};

// ----------------------------------------------------------------
// Modèle de configuration d'un univers
// ----------------------------------------------------------------
class _UniversConfig {
  final String displayName;
  final Color primaryColor;
  final Color secondaryColor;
  final String description;

  const _UniversConfig({
    required this.displayName,
    required this.primaryColor,
    required this.secondaryColor,
    required this.description,
  });
}

// ----------------------------------------------------------------
// L'écran 9 lui-même
// ----------------------------------------------------------------
class Screen9UniverseIntro extends StatefulWidget {
  final PlayerData player;

  const Screen9UniverseIntro({super.key, required this.player});

  @override
  State<Screen9UniverseIntro> createState() => _Screen9UniverseIntroState();
}

class _Screen9UniverseIntroState extends State<Screen9UniverseIntro>
    with SingleTickerProviderStateMixin {

  late AnimationController _appearController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    // Animation d'apparition au chargement de l'écran
    _appearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _appearController, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _appearController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _appearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Récupère la config de l'univers choisi (avec fallback si inconnu)
    final config = _universConfigs[widget.player.filiere] ??
        _universConfigs['MEWO INFORMATIQUE']!;

    return Scaffold(
      body: FuturisticBackground(
        primaryColor: config.primaryColor,
        secondaryColor: config.secondaryColor,
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // ---- QUIZ ARENA (titre principal) ----
                FadeTransition(
                  opacity: _fadeIn,
                  child: _NeonText(
                    text: 'QUIZ ARENA',
                    fontSize: 36,
                    color: Colors.white,
                    glowColor: config.primaryColor,
                  ),
                ),

                const SizedBox(height: 16),

                // ---- Nom de l'univers ----
                FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideIn,
                    child: _NeonText(
                      text: config.displayName,
                      fontSize: 28,
                      color: config.primaryColor,
                      glowColor: config.primaryColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ---- Boîte explicative ----
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideIn,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            // Fond blanc semi-transparent (comme dans l'image)
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: config.primaryColor.withOpacity(0.4),
                              width: 1.5,
                            ),
                            // Lueur néon sur les bords
                            boxShadow: [
                              BoxShadow(
                                color: config.primaryColor.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              config.description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.7,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ---- NIVEAU 1 ----
                FadeTransition(
                  opacity: _fadeIn,
                  child: _NeonText(
                    text: 'NIVEAU 1',
                    fontSize: 32,
                    color: Colors.white,
                    glowColor: config.secondaryColor,
                  ),
                ),

                const SizedBox(height: 20),

                // ---- Boutons Précédent / Suivant ----
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Précédent
                      _NeonButton(
                        label: '← Précédent',
                        color: config.primaryColor,
                        onTap: () => Navigator.pop(context),
                      ),

                      // Suivant → vers le quiz (écran 10)
                      _NeonButton(
                        label: 'Jouer ! →',
                        color: config.secondaryColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Screen10Quiz(
                                player: widget.player,
                                niveau: 1,
                              ),
                            ),
                          );
                        },
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
}

// ----------------------------------------------------------------
// Widget : Texte néon avec lueur
// ----------------------------------------------------------------
class _NeonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final Color glowColor;
  final TextAlign textAlign;

  const _NeonText({
    required this.text,
    required this.fontSize,
    required this.color,
    required this.glowColor,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        color: color,
        letterSpacing: 2,
        shadows: [
          // Lueur néon (plusieurs couches pour l'effet)
          Shadow(color: glowColor.withOpacity(0.8), blurRadius: 8),
          Shadow(color: glowColor.withOpacity(0.4), blurRadius: 20),
          Shadow(color: glowColor.withOpacity(0.2), blurRadius: 40),
          // Contour sombre pour la lisibilité
          const Shadow(color: Colors.black87, offset: Offset(1, 1), blurRadius: 3),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------
// Widget : Bouton néon
// ----------------------------------------------------------------
class _NeonButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _NeonButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color, width: 1.5),
          color: color.withOpacity(0.15),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 12),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
            shadows: [Shadow(color: color.withOpacity(0.5), blurRadius: 6)],
          ),
        ),
      ),
    );
  }
}