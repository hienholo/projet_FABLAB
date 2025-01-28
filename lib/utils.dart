String? inputValidator(String value, String inputType,) {
  if (value.isEmpty) {
    return 'Ce champ est obligatoire.';
  }

  switch (inputType) {
    case 'email':
      final emailRegex = RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Veuillez entrer une adresse e-mail valide.';
      }
      break;

    case 'password':
      if (value.length < 6) {
        return 'Le mot de passe doit contenir au moins 6 caractères.';
      }
      break;

    case 'phone':
      final phoneRegex = RegExp(r'^\d{10,15}$');
      if (!phoneRegex.hasMatch(value)) {
        return 'Veuillez entrer un numéro de téléphone valide.';
      }
      break;

    case 'number':
      if (double.tryParse(value) == null) {
        return 'Veuillez entrer un nombre valide.';
      }
      break;

    default:
      // Pas de validation spécifique pour un champ texte générique
      break;
  }

  return null; // Aucune erreur, la validation passe
}
