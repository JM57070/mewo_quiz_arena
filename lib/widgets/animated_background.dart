// ============================================================
// widgets/animated_background.dart
// Arrière-plan animé réutilisable sur tous les écrans
// Nuages qui bougent + herbe qui ondule
// ============================================================

import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  // Contrôleurs d'animation
  late AnimationController _cloudController;
  late AnimationController _grassController;

  late Animation<double> _cloud1Anim;
  late Animation<double> _cloud2Anim;
  late Animation<double> _grassAnim;

  @override
  void initState() {
    super.initState();

    // --- Nuages : mouvement de gauche à droite, boucle infinie ---
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(); // répète en boucle

    _cloud1Anim = Tween<double>(begin: -200, end: 420).animate(
      CurvedAnimation(parent: _cloudController, curve: Curves.linear),
    );

    _cloud2Anim = Tween<double>(begin: 100, end: 700).animate(
      CurvedAnimation(parent: _cloudController, curve: Curves.linear),
    );

    // --- Herbe : oscillation douce (va-et-vient) ---
    _grassController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _grassAnim = Tween<double>(begin: -3, end: 3).animate(
      CurvedAnimation(parent: _grassController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _grassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // --- Image de fond (remplace par ton image dans assets/) ---
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg_campus.png',
            fit: BoxFit.cover,
            // Si l'image n'existe pas encore, on affiche un dégradé
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF5BB8F5), Color(0xFF87CEEB), Color(0xFF4CAF50)],
                  stops: [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
        ),

        // --- Nuage 1 ---
        AnimatedBuilder(
          animation: _cloud1Anim,
          builder: (_, __) => Positioned(
            top: 80,
            left: _cloud1Anim.value,
            child: _CloudShape(width: 120, opacity: 0.85),
          ),
        ),

        // --- Nuage 2 (plus petit, décalé) ---
        AnimatedBuilder(
          animation: _cloud2Anim,
          builder: (_, __) => Positioned(
            top: 140,
            left: _cloud2Anim.value - 300,
            child: _CloudShape(width: 80, opacity: 0.7),
          ),
        ),

        // --- Herbe animée en bas ---
        AnimatedBuilder(
          animation: _grassAnim,
          builder: (_, __) => Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Transform.translate(
              offset: Offset(_grassAnim.value, 0),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ),

        // --- Contenu de l'écran par-dessus ---
        widget.child,
      ],
    );
  }
}

// ------- Forme nuage simple dessinée avec Flutter -------
class _CloudShape extends StatelessWidget {
  final double width;
  final double opacity;

  const _CloudShape({required this.width, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: SizedBox(
        width: width,
        height: width * 0.6,
        child: CustomPaint(painter: _CloudPainter()),
      ),
    );
  }
}

class _CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    // Corps principal
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.4, size.width * 0.8, size.height * 0.5),
      paint,
    );
    // Bosse gauche
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.45), size.width * 0.2, paint);
    // Bosse centre
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.3), size.width * 0.25, paint);
    // Bosse droite
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.42), size.width * 0.18, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
