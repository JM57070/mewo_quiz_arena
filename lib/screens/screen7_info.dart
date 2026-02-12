// ============================================================
// screens/screen7_info.dart
// ÉCRAN 7 : Formulaire nom / prénom / date de naissance
// ============================================================

import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../widgets/mewo_widgets.dart';
import '../models/player_data.dart';
import 'screen8_universe.dart';

class Screen7Info extends StatefulWidget {
  final PlayerData player; // On reçoit le PlayerData de l'écran 6

  const Screen7Info({super.key, required this.player});

  @override
  State<Screen7Info> createState() => _Screen7InfoState();
}

class _Screen7InfoState extends State<Screen7Info> {
  // Contrôleurs pour lire ce que l'utilisateur tape
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _dateController = TextEditingController();

  // Clé pour valider le formulaire
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Toujours libérer les contrôleurs !
    _nomController.dispose();
    _prenomController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _valider() {
    // Vérifie que tous les champs sont remplis
    if (_formKey.currentState!.validate()) {
      // Remplit le PlayerData avec les infos saisies
      widget.player.nom = _nomController.text.trim();
      widget.player.prenom = _prenomController.text.trim();
      widget.player.dateNaissance = _dateController.text.trim();

      // Affiche les données en console pour vérifier (debug)
      debugPrint('Données joueur : ${widget.player}');

      // Navigation vers écran 8
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Screen8Universe(player: widget.player),
        ),
      );
    }
  }

  // Ouvre le sélecteur de date natif Flutter
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),          // Date par défaut
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),     // Calendrier en français
    );
    if (picked != null) {
      setState(() {
        // Format JJ/MM/AAAA
        _dateController.text =
            '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Image du personnage choisi
    final assetName = widget.player.personnage == 'garcon'
        ? 'assets/images/perso_garcon.png'
        : 'assets/images/perso_fille.png';

    return Scaffold(
      // Évite que le clavier pousse le contenu
      resizeToAvoidBottomInset: true,
      body: AnimatedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 25),

                // ---- Logo ----
                const MewoLogo(),

                const SizedBox(height: 10),

                // ---- Titre ----
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Remplie tes informations\npour rejoindre l\'arène du Quiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(1, 1)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ---- Personnage ----
                Image.asset(
                  assetName,
                  height: 180,
                  errorBuilder: (_, __, ___) => Icon(
                    widget.player.personnage == 'garcon'
                        ? Icons.man
                        : Icons.woman,
                    size: 100,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 15),

                // ---- Formulaire ----
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        _buildField(
                          controller: _nomController,
                          label: 'Nom',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          controller: _prenomController,
                          label: 'Prénom',
                          icon: Icons.badge_outlined,
                        ),
                        const SizedBox(height: 12),
                        // Champ date avec sélecteur
                        _buildDateField(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ---- Bouton Valider ----
                MewoButton(
                  label: 'VALIDER',
                  onTap: _valider,
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- Champ texte stylisé ----
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.blue.withOpacity(0.25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white38),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white38),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      // Validation : champ obligatoire
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ce champ est obligatoire';
        }
        return null;
      },
    );
  }

  // ---- Champ date (lecture seule + sélecteur) ----
  Widget _buildDateField() {
    return TextFormField(
      controller: _dateController,
      readOnly: true, // L'utilisateur ne peut pas taper directement
      onTap: _pickDate,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: 'Date de naissance',
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
        suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
        filled: true,
        fillColor: Colors.blue.withOpacity(0.25),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white38),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Sélectionne ta date de naissance';
        }
        return null;
      },
    );
  }
}
