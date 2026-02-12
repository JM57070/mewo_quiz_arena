// ============================================================
// screens/screen8_universe.dart — NOUVEAU DESIGN
// Carte circulaire avec navigation par flèches directionnelles
// ============================================================

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/animated_background.dart';
import '../widgets/mewo_widgets.dart';
import '../models/player_data.dart';
import 'screen9_universe_intro.dart';

// ----------------------------------------------------------------
// Configuration des 5 univers + accueil central
// ----------------------------------------------------------------
class _UniversPoint {
  final String id;
  final String nom;
  final Color couleur;
  final IconData icone;

  const _UniversPoint({
    required this.id,
    required this.nom,
    required this.couleur,
    required this.icone,
  });
}

const List<_UniversPoint> _univers = [
  _UniversPoint(
    id: 'ACCUEIL',
    nom: 'ACCUEIL\nCAMPUS',
    couleur: Color(0xFFFFFFFF),
    icone: Icons.home,
  ),
  _UniversPoint(
    id: 'MEWO ANIMAL',
    nom: 'MEWO\nANIMAL',
    couleur: Color(0xFFE91E63),
    icone: Icons.pets,
  ),
  _UniversPoint(
    id: 'MEWO JURIDIQUE',
    nom: 'MEWO\nJURIDIQUE',
    couleur: Color(0xFF9C27B0),
    icone: Icons.gavel,
  ),
  _UniversPoint(
    id: 'MEWO INFORMATIQUE',
    nom: 'MEWO\nINFORMATIQUE',
    couleur: Color(0xFFFFEB3B),
    icone: Icons.computer,
  ),
  _UniversPoint(
    id: 'MEWO SERVICE',
    nom: 'MEWO\nSERVICE',
    couleur: Color(0xFF2196F3),
    icone: Icons.handshake,
  ),
  _UniversPoint(
    id: 'MEWO SANTE',
    nom: 'MEWO\nSANTÉ',
    couleur: Color(0xFF4CAF50),
    icone: Icons.favorite,
  ),
];

// ----------------------------------------------------------------
// L'écran avec la carte circulaire
// ----------------------------------------------------------------
class Screen8Universe extends StatefulWidget {
  final PlayerData player;

  const Screen8Universe({super.key, required this.player});

  @override
  State<Screen8Universe> createState() => _Screen8UniverseState();
}

class _Screen8UniverseState extends State<Screen8Universe>
    with SingleTickerProviderStateMixin {

  int _selectedIndex = 0; // 0 = Accueil, 1-5 = Univers
  late AnimationController _moveController;
  late Animation<double> _moveAnim;
  int _targetIndex = 0;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _moveAnim = CurvedAnimation(parent: _moveController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _moveController.dispose();
    super.dispose();
  }

  // ---- Navigation circulaire ----
  void _moveLeft() {
    setState(() {
      _targetIndex = _selectedIndex;
      if (_selectedIndex == 0) {
        // De l'accueil, on va au dernier univers (5)
        _selectedIndex = _univers.length - 1;
      } else {
        // Sinon on recule d'un cran (sens anti-horaire)
        _selectedIndex = (_selectedIndex - 1);
        if (_selectedIndex == 0) _selectedIndex = _univers.length - 1;
      }
      _moveController.forward(from: 0);
    });
  }

  void _moveRight() {
    setState(() {
      _targetIndex = _selectedIndex;
      if (_selectedIndex == 0) {
        // De l'accueil, on va au premier univers (1)
        _selectedIndex = 1;
      } else {
        // Sinon on avance d'un cran (sens horaire)
        _selectedIndex = (_selectedIndex % (_univers.length - 1)) + 1;
      }
      _moveController.forward(from: 0);
    });
  }

  void _enterUniverse() {
    if (_selectedIndex == 0) {
      // On est sur l'accueil, rien à faire
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sélectionne un univers avec les flèches !'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Sélectionne la filière et navigue vers l'écran 9
    widget.player.filiere = _univers[_selectedIndex].id;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Screen9UniverseIntro(player: widget.player),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mapRadius = math.min(size.width, size.height) * 0.35;

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ---- Logo ----
              const MewoLogo(),

              const SizedBox(height: 12),

              // ---- Titre ----
              const Text(
                'CHOISIE TA CLASSE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(color: Colors.white, offset: Offset(1, 1), blurRadius: 3),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---- Carte circulaire ----
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: mapRadius * 2.5,
                    height: mapRadius * 2.5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Fond de la carte (cercle)
                        CustomPaint(
                          size: Size(mapRadius * 2.5, mapRadius * 2.5),
                          painter: _CircularMapPainter(
                            radius: mapRadius,
                            selectedIndex: _selectedIndex,
                          ),
                        ),

                        // Points des univers
                        ..._buildUniversPoints(mapRadius),

                        // Personnage animé
                        _buildCharacter(mapRadius),
                      ],
                    ),
                  ),
                ),
              ),

              // ---- Infos de l'univers sélectionné ----
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _univers[_selectedIndex].couleur.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _univers[_selectedIndex].couleur,
                    width: 2,
                  ),
                ),
                child: Text(
                  _univers[_selectedIndex].nom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _univers[_selectedIndex].couleur,
                    shadows: const [
                      Shadow(color: Colors.white, blurRadius: 4),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---- Contrôles directionnels ----
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Flèche Gauche
                  _DirectionalButton(
                    icon: Icons.arrow_back,
                    onTap: _moveLeft,
                  ),

                  const SizedBox(width: 30),

                  // Bouton Entrer
                  GestureDetector(
                    onTap: _enterUniverse,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: _univers[_selectedIndex].couleur.withOpacity(0.3),
                        border: Border.all(
                          color: _univers[_selectedIndex].couleur,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _univers[_selectedIndex].couleur.withOpacity(0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.login,
                            color: _univers[_selectedIndex].couleur,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ENTRER',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _univers[_selectedIndex].couleur,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 30),

                  // Flèche Droite
                  _DirectionalButton(
                    icon: Icons.arrow_forward,
                    onTap: _moveRight,
                  ),
                ],
              ),


              const SizedBox(height: 12),

              // ---- Bouton Précédent ----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white.withOpacity(0.15),
                        border: Border.all(color: Colors.white60, width: 1.5),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Précédent',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Dessine les 6 points sur la carte ----
  List<Widget> _buildUniversPoints(double mapRadius) {
    List<Widget> points = [];

    for (int i = 0; i < _univers.length; i++) {
      Offset position;

      if (i == 0) {
        // Accueil au centre
        position = Offset.zero;
      } else {
        // Les 5 univers en cercle autour
        // Commence à 12h (-90°) et tourne dans le sens horaire
        double angle = -math.pi / 2 + ((i - 1) * 2 * math.pi / 5);
        position = Offset(
          mapRadius * math.cos(angle),
          mapRadius * math.sin(angle),
        );
      }

      points.add(
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Transform.translate(
            offset: const Offset(-30, -30), // Centre le widget de 60x60
            child: _UniversMarker(
              point: _univers[i],
              isSelected: _selectedIndex == i,
              isCenter: i == 0,
            ),
          ),
        ),
      );
    }

    return points;
  }

  // ---- Personnage qui se déplace ----
  Widget _buildCharacter(double mapRadius) {
    // Position actuelle
    Offset currentPos;
    if (_selectedIndex == 0) {
      currentPos = Offset.zero;
    } else {
      double angle = -math.pi / 2 + ((_selectedIndex - 1) * 2 * math.pi / 5);
      currentPos = Offset(
        mapRadius * math.cos(angle),
        mapRadius * math.sin(angle),
      );
    }

    // Position précédente (pour l'animation)
    Offset previousPos;
    if (_targetIndex == 0) {
      previousPos = Offset.zero;
    } else {
      double angle = -math.pi / 2 + ((_targetIndex - 1) * 2 * math.pi / 5);
      previousPos = Offset(
        mapRadius * math.cos(angle),
        mapRadius * math.sin(angle),
      );
    }

    return AnimatedBuilder(
      animation: _moveAnim,
      builder: (_, __) {
        // Interpolation entre previous et current
        final pos = Offset.lerp(previousPos, currentPos, _moveAnim.value)!;

        return Transform.translate(
          offset: pos,
          child: Transform.translate(
            offset: const Offset(-20, -40), // Décale pour être au-dessus du point
            child: Image.asset(
              widget.player.personnage == 'garcon'
                  ? 'assets/images/perso_garcon.png'
                  : 'assets/images/perso_fille.png',
              height: 80,
              errorBuilder: (_, __, ___) => Icon(
                widget.player.personnage == 'garcon' ? Icons.man : Icons.woman,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------------------
// Painter : Dessine la carte circulaire avec lignes
// ----------------------------------------------------------------
class _CircularMapPainter extends CustomPainter {
  final double radius;
  final int selectedIndex;

  _CircularMapPainter({required this.radius, required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Cercle de fond (zone jouable)
    canvas.drawCircle(
      center,
      radius * 1.15,
      Paint()
        ..color = Colors.white.withOpacity(0.1)
        ..style = PaintingStyle.fill,
    );

    // Contour du cercle
    canvas.drawCircle(
      center,
      radius * 1.15,
      Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Lignes depuis le centre vers chaque univers
    for (int i = 1; i <= 5; i++) {
      double angle = -math.pi / 2 + ((i - 1) * 2 * math.pi / 5);
      Offset universePos = center + Offset(
        radius * math.cos(angle),
        radius * math.sin(angle),
      );

      canvas.drawLine(
        center,
        universePos,
        Paint()
          ..color = (selectedIndex == i)
              ? _univers[i].couleur.withOpacity(0.6)
              : Colors.white.withOpacity(0.2)
          ..strokeWidth = (selectedIndex == i) ? 3 : 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularMapPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;
}

// ----------------------------------------------------------------
// Marqueur d'univers sur la carte
// ----------------------------------------------------------------
class _UniversMarker extends StatelessWidget {
  final _UniversPoint point;
  final bool isSelected;
  final bool isCenter;

  const _UniversMarker({
    required this.point,
    required this.isSelected,
    required this.isCenter,
  });

  @override
  Widget build(BuildContext context) {
    final size = isCenter ? 70.0 : 60.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: point.couleur.withOpacity(isCenter ? 0.3 : 0.2),
        border: Border.all(
          color: isSelected ? point.couleur : point.couleur.withOpacity(0.5),
          width: isSelected ? 4 : 2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: point.couleur.withOpacity(0.5),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Icon(
        point.icone,
        color: isSelected ? point.couleur : point.couleur.withOpacity(0.7),
        size: isCenter ? 32 : 28,
      ),
    );
  }
}

// ----------------------------------------------------------------
// Bouton directionnel (flèche)
// ----------------------------------------------------------------
class _DirectionalButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DirectionalButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
          border: Border.all(color: Colors.white70, width: 2),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}