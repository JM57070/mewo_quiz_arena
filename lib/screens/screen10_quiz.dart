// ============================================================
// screens/screen10_quiz.dart
// ÉCRAN 10 : Quiz avec questions/réponses
// ============================================================

import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/futuristic_background.dart';
import '../models/player_data.dart';
import '../models/quiz_question.dart';

class Screen10Quiz extends StatefulWidget {
  final PlayerData player;
  final int niveau; // 1, 2 ou 3

  const Screen10Quiz({
    super.key,
    required this.player,
    this.niveau = 1,
  });

  @override
  State<Screen10Quiz> createState() => _Screen10QuizState();
}

class _Screen10QuizState extends State<Screen10Quiz>
    with SingleTickerProviderStateMixin {

  int _currentQuestionIndex = 0;
  String? _selectedAnswer; // A, B, C ou D
  String _displayedQuestion = '';
  bool _isTyping = true;
  Timer? _typingTimer;

  // Couleurs selon l'univers (récupérées de screen9)
  late Color _primaryColor;
  late Color _secondaryColor;

  late AnimationController _appearController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _initColors();
    _appearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _appearController, curve: Curves.easeOut);
    
    _startTyping();
  }

  void _initColors() {
    // Récupère les couleurs selon la filière
    switch (widget.player.filiere) {
      case 'MEWO ANIMAL':
        _primaryColor = const Color(0xFF00E676);
        _secondaryColor = const Color(0xFF76FF03);
        break;
      case 'MEWO JURIDIQUE':
        _primaryColor = const Color(0xFFAA00FF);
        _secondaryColor = const Color(0xFFE040FB);
        break;
      case 'MEWO INFORMATIQUE':
        _primaryColor = const Color(0xFF00E5FF);
        _secondaryColor = const Color(0xFFAA00FF);
        break;
      case 'MEWO SERVICE':
        _primaryColor = const Color(0xFF0091EA);
        _secondaryColor = const Color(0xFF00B8D4);
        break;
      case 'MEWO SANTE':
        _primaryColor = const Color(0xFF00E676);
        _secondaryColor = const Color(0xFF1DE9B6);
        break;
      default:
        _primaryColor = const Color(0xFF00E5FF);
        _secondaryColor = const Color(0xFFAA00FF);
    }
  }

  // Animation machine à écrire pour la question
  void _startTyping() {
    final question = questionsNiveau1[_currentQuestionIndex];
    final fullText = question.question;
    int index = 0;
    _displayedQuestion = '';
    _isTyping = true;

    _typingTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (index < fullText.length) {
        setState(() {
          _displayedQuestion += fullText[index];
          index++;
        });
      } else {
        timer.cancel();
        setState(() => _isTyping = false);
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _appearController.dispose();
    super.dispose();
  }

  void _selectAnswer(String letter) {
    if (!_isTyping) {
      setState(() => _selectedAnswer = letter);
    }
  }

  void _goNext() {
    if (_selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _primaryColor.withOpacity(0.8),
          content: const Text('Sélectionne une réponse d\'abord !'),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    // TODO : Stocker la réponse pour le scoring final
    debugPrint('Question ${_currentQuestionIndex + 1} → Réponse $_selectedAnswer');

    if (_currentQuestionIndex < questionsNiveau1.length - 1) {
      // Passe à la question suivante
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _typingTimer?.cancel();
      });
      _appearController.forward(from: 0);
      _startTyping();
    } else {
      // Fin du niveau → afficher récap (TODO écran 11)
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(
            '🎉 Niveau ${widget.niveau} terminé !',
            style: TextStyle(color: _primaryColor),
          ),
          content: const Text(
            'Bravo ! Tu as complété toutes les questions.\n\n'
            'Prochaine étape : récapitulatif et orientation.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Ferme la dialog
                Navigator.pop(context); // Retour à l'écran 9
              },
              child: Text('OK', style: TextStyle(color: _secondaryColor)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questionsNiveau1[_currentQuestionIndex];

    return Scaffold(
      body: FuturisticBackground(
        primaryColor: _primaryColor,
        secondaryColor: _secondaryColor,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // ---- En-tête : "LE DÉFI DU MATIN" + "Question X" ----
                _buildHeader(question),

                const SizedBox(height: 30),

                // ---- La question avec typing ----
                _buildQuestionText(question),

                const SizedBox(height: 30),

                // ---- Les 4 réponses ----
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: question.reponses
                          .map((answer) => _buildAnswerBox(answer))
                          .toList(),
                    ),
                  ),
                ),

                // ---- Détection + Niveau + Univers ----
                _buildFooter(question),

                const SizedBox(height: 10),

                // ---- Bouton Suivant ----
                Padding(
                  padding: const EdgeInsets.only(right: 24, bottom: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _NeonButton(
                      label: 'Suivant →',
                      color: _secondaryColor,
                      onTap: _goNext,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- En-tête (défi + numéro question) ----
  Widget _buildHeader(QuizQuestion question) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // "LE DÉFI DU MATIN" incliné avec dégradé
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Transform.rotate(
            angle: -0.1, // légère inclinaison
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [_primaryColor, _secondaryColor],
              ).createShader(bounds),
              child: const Text(
                'LE DÉFI\nDU MATIN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: 1,
                  shadows: [
                    Shadow(color: Colors.black, blurRadius: 4),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Numéro de la question
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            'Question ${question.numero}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2,
              shadows: [
                Shadow(color: _primaryColor.withOpacity(0.7), blurRadius: 12),
                const Shadow(color: Colors.black, offset: Offset(2, 2)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---- Texte de la question (avec typing) ----
  Widget _buildQuestionText(QuizQuestion question) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _primaryColor.withOpacity(0.3)),
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.4),
            _primaryColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            _displayedQuestion,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.5,
              shadows: [Shadow(color: Colors.black, blurRadius: 3)],
            ),
          ),
          if (_isTyping)
            const Text('|', style: TextStyle(color: Colors.white, fontSize: 20)),
        ],
      ),
    );
  }

  // ---- Boîte de réponse ----
  Widget _buildAnswerBox(QuizAnswer answer) {
    final isSelected = _selectedAnswer == answer.letter;

    return GestureDetector(
      onTap: () => _selectAnswer(answer.letter),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? _primaryColor.withOpacity(0.25)
              : Colors.white.withOpacity(0.08),
          border: Border.all(
            color: isSelected ? _primaryColor : Colors.white.withOpacity(0.3),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: _primaryColor.withOpacity(0.4), blurRadius: 16)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lettre + texte
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icône "?"
                Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _primaryColor.withOpacity(0.2),
                    border: Border.all(color: _primaryColor, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      answer.letter,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                  ),
                ),
                // Texte de la réponse
                Expanded(
                  child: Text(
                    answer.text,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
                // Icône "?" à droite
                Icon(Icons.help_outline, color: _primaryColor.withOpacity(0.5), size: 20),
              ],
            ),
            const SizedBox(height: 8),
            // Profil détecté (petit texte)
            Text(
              answer.profil,
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Pied de page (détecte + niveau + univers) ----
  Widget _buildFooter(QuizQuestion question) {
    return Column(
      children: [
        // Texte "Détecte : ..."
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Détecte : ${question.detecte}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Colors.white70,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Niveau + Univers
        Text(
          'NIVEAU ${widget.niveau}',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
            shadows: [
              Shadow(color: _secondaryColor.withOpacity(0.8), blurRadius: 10),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.player.filiere,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------------
// Bouton néon réutilisé de screen9
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color, width: 2),
          color: color.withOpacity(0.2),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.4), blurRadius: 12),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
            shadows: [Shadow(color: color.withOpacity(0.5), blurRadius: 6)],
          ),
        ),
      ),
    );
  }
}