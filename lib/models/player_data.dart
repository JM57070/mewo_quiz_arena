// ============================================================
// models/player_data.dart
// Stocke les données du joueur collectées pendant l'onboarding
// ============================================================

class PlayerData {
  String nom;
  String prenom;
  String dateNaissance;
  String personnage;    // 'garcon' ou 'fille'
  String filiere;       // ex: 'MEWO INFORMATIQUE'

  PlayerData({
    this.nom = '',
    this.prenom = '',
    this.dateNaissance = '',
    this.personnage = '',
    this.filiere = '',
  });

  // Convertit en Map pour l'export JSON ou Firebase plus tard
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'date_naissance': dateNaissance,
      'personnage': personnage,
      'filiere': filiere,
    };
  }

  @override
  String toString() {
    return 'PlayerData(nom: $nom, prenom: $prenom, '
        'dateNaissance: $dateNaissance, '
        'personnage: $personnage, filiere: $filiere)';
  }
}
