class OpeningPorteModel {
  
  OpeningPorteModel({
    required this.titrePorte,
    required this.nomUtilisateur,
    required this.dureeOuverture,
  });

  // Constructeur à partir d'un JSON
  OpeningPorteModel.fromJson(Map<String, dynamic> json) {
    titrePorte = json['titrePorte'];
    nomUtilisateur = json['nomUtilisateur'];
    dureeOuverture = json['dureeOuverture'];
  }

  // Champs
  String? titrePorte;
  String? nomUtilisateur;
  String? dureeOuverture;

  // Convertir l'objet en JSON
  Map<String, dynamic> toJson() {
    return {
      'titrePorte': titrePorte,
      'nomUtilisateur': nomUtilisateur,
      'dureeOuverture': dureeOuverture,
    };
  }
}