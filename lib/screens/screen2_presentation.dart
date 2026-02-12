// ============================================================
// screens/screen2_presentation.dart
// ÉCRANS 2 à 5 : Présentation avec bulle de texte animée
// Un seul widget réutilisé pour les 4 écrans grâce à pageIndex
// ============================================================

import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/animated_background.dart';
import '../widgets/mewo_widgets.dart';
import 'screen6_character.dart';

// ---- Données de chaque page ----
const List<Map<String, String>> _pages = [
  {
    'subtitle': 'Présentation',
    'text':
        'Depuis plus de 10 ans, MEWO s\'impose comme un acteur incontournable de la formation à Metz… et aujourd\'hui, nous passons au niveau supérieur avec MEWO Quiz Arena, l\'application mobile qui transforme votre découverte du campus en véritable aventure interactive !',
  },
  {
    'subtitle': 'Présentation',
    'text':
        'Plongez dans un univers ludique et moderne ! Débloquez des niveaux, relevez des défis et testez vos connaissances sur les métiers, les formations et la vie étudiante.',
  },
  {
    'subtitle': 'Explication',
    'text':
        'Programme du MEWO Quiz Arena :\n• Quiz thématiques par niveau\n• Classements, récompenses, badges\n• Missions spéciales liées aux formations et aux métiers',
  },
  {
    'subtitle': 'Explication',
    'text': 'Prêt à jouer, apprendre et monter en compétences ?',
  },
];

class Screen2Presentation extends StatefulWidget {
  final int pageIndex; // 0=écran2, 1=écran3, 2=écran4, 3=écran5

  const Screen2Presentation({super.key, required this.pageIndex});

  @override
  State<Screen2Presentation> createState() => _Screen2PresentationState();
}

class _Screen2PresentationState extends State<Screen2Presentation> {
  String _displayedText = ''; // Texte affiché progressivement
  bool _isTyping = true;      // Animation d'écriture en cours ?
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  // ---- Animation "machine à écrire" ----
  void _startTyping() {
    final fullText = _pages[widget.pageIndex]['text']!;
    int index = 0;
    _displayedText = '';
    _isTyping = true;

    _typingTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (index < fullText.length) {
        setState(() {
          _displayedText += fullText[index];
          index++;
        });
      } else {
        // Animation terminée
        timer.cancel();
        setState(() => _isTyping = false);
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  void _goNext() {
    // Si on est encore en train d'écrire, on affiche tout d'un coup
    if (_isTyping) {
      _typingTimer?.cancel();
      setState(() {
        _displayedText = _pages[widget.pageIndex]['text']!;
        _isTyping = false;
      });
      return;
    }

    // Dernier écran de présentation → écran 6
    if (widget.pageIndex >= _pages.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Screen6Character()),
      );
    } else {
      // Sinon, on passe à la page suivante
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Screen2Presentation(pageIndex: widget.pageIndex + 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = _pages[widget.pageIndex]['subtitle']!;
    final isLastPage = widget.pageIndex >= _pages.length - 1;

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),

              // ---- Logo ----
              const MewoLogo(),

              // ---- Sous-titre (ex: "Présentation") ----
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---- Rangée : Personnage + Bulle ----
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Personnage à gauche
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.asset(
                        'assets/images/perso_directeur.png',
                        height: 220,
                        errorBuilder: (_, __, ___) => _FallbackCharacter(),
                      ),
                    ),

                    // Bulle de texte animée
                    Expanded(
                      child: GestureDetector(
                        onTap: _goNext, // Tap sur la bulle = avancer
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white54, width: 1.5),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _displayedText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                              ),
                              // Curseur clignotant pendant l'écriture
                              if (_isTyping)
                                const Text('|',
                                    style: TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ---- Boutons en bas ----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Bouton "précédent" uniquement sur le dernier écran
                    if (isLastPage)
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white.withOpacity(0.2),
                            border: Border.all(color: Colors.white60),
                          ),
                          child: const Text('← Précédent',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                        ),
                      )
                    else
                      const SizedBox(),

                    // Bouton "suivant" toujours à droite
                    NextButton(onTap: _goNext),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Personnage de remplacement si l'image n'existe pas encore
class _FallbackCharacter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 60, color: Colors.white),
          Text('Directeur', style: TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}
