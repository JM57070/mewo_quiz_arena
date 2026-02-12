// ============================================================
// models/quiz_question.dart
// Modèle pour stocker une question de quiz
// ============================================================

class QuizQuestion {
  final int numero;
  final String question;
  final List<QuizAnswer> reponses;
  final String detecte; // Ce que la question détecte (affiché en bas)

  const QuizQuestion({
    required this.numero,
    required this.question,
    required this.reponses,
    required this.detecte,
  });
}

class QuizAnswer {
  final String letter;     // A, B, C, D
  final String text;       // Texte de la réponse
  final String profil;     // Ex: "profil technique → informatique / santé"
  final List<String> tags; // Pour le scoring : ['technique', 'informatique', 'sante']

  const QuizAnswer({
    required this.letter,
    required this.text,
    required this.profil,
    required this.tags,
  });
}

// ============================================================
// Base de données des questions - Niveau 1 Informatique
// ============================================================

const List<QuizQuestion> questionsNiveau1 = [
  QuizQuestion(
    numero: 1,
    question: 'Tu te réveilles pour une mission spéciale. Quel est ton premier réflexe ?',
    detecte: 'organisation, rigueur, mode d\'apprentissage.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Vérifier ton équipement, tout doit être prêt.',
        profil: 'profil technique → informatique / santé',
        tags: ['technique', 'organisation', 'informatique', 'sante'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Observer ton environnement et t\'assurer que tout le monde va bien.',
        profil: 'profil empathique → santé / service',
        tags: ['empathique', 'sante', 'service'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Noter les objectifs de ta journée dans ton carnet.',
        profil: 'profil rigoureux → juridique',
        tags: ['rigoureux', 'organisation', 'juridique'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Sortir directement, tu préfères apprendre en faisant.',
        profil: 'profil manuel → animalier / service',
        tags: ['manuel', 'pratique', 'animal', 'service'],
      ),
    ],
  ),
  
  QuizQuestion(
    numero: 2,
    question: 'Dans une équipe de jeu, tu préfères incarner…',
    detecte: 'rôle préféré, compétences naturelles.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Le stratège qui analyse et prend des décisions.',
        profil: 'profil analytique → informatique / juridique',
        tags: ['analytique', 'strategie', 'informatique', 'juridique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Le soigneur qui s\'occupe des autres.',
        profil: 'profil empathique → santé',
        tags: ['empathique', 'soin', 'sante'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Le dresseur/éleveur qui s\'occupe des créatures.',
        profil: 'profil animalier → animal',
        tags: ['animal', 'soin', 'patience'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Le multitâche qui aide partout selon les besoins.',
        profil: 'profil polyvalent → service',
        tags: ['polyvalent', 'service', 'adaptabilite'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 3,
    question: 'Tu dois résoudre un problème en 10 secondes. Comment t\'y prends-tu ?',
    detecte: 'méthode de résolution, gestion du stress.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Je respire, je réfléchis étape par étape.',
        profil: 'profil méthodique → informatique / juridique',
        tags: ['methodique', 'reflexion', 'informatique', 'juridique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Je fonce et je teste directement.',
        profil: 'profil action → service / animal',
        tags: ['action', 'pratique', 'service', 'animal'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'J\'écoute les indices autour de moi avant d\'agir.',
        profil: 'profil observateur → santé / service',
        tags: ['observation', 'empathie', 'sante', 'service'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Je cherche un modèle ou une règle pour répondre vite.',
        profil: 'profil structuré → juridique',
        tags: ['structure', 'regles', 'juridique'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 4,
    question: 'Si ton lieu idéal existait dans un jeu, il ressemblerait à…',
    detecte: 'environnement préféré, centres d\'intérêt.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Un laboratoire high-tech rempli d\'écrans.',
        profil: 'profil technologique → informatique',
        tags: ['technologie', 'informatique', 'innovation'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Une forêt vivante pleine d\'animaux.',
        profil: 'profil nature → animal',
        tags: ['nature', 'animal', 'biodiversite'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Une grande salle d\'étude calme et ordonnée.',
        profil: 'profil studieux → juridique',
        tags: ['etude', 'calme', 'juridique', 'organisation'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Une base où l\'on soigne les alliés blessés.',
        profil: 'profil soignant → santé',
        tags: ['soin', 'aide', 'sante', 'empathie'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 5,
    question: 'Choisis la mission qui te motive le plus.',
    detecte: 'motivation profonde, projet de carrière.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Régler un problème technique complexe.',
        profil: 'profil technique → informatique',
        tags: ['technique', 'resolution', 'informatique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Apporter du soutien ou du réconfort à quelqu\'un.',
        profil: 'profil empathique → santé / service',
        tags: ['empathie', 'soutien', 'sante', 'service'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Comprendre et appliquer des règles précises.',
        profil: 'profil juridique → juridique',
        tags: ['regles', 'precision', 'juridique'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Prendre soin d\'êtres vivants.',
        profil: 'profil animalier → animal / santé',
        tags: ['soin', 'vivant', 'animal', 'sante'],
      ),
    ],
  ),
];
