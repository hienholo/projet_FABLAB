import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fablabs7/pages/httpRequest.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  // 🎯 Contrôleurs de texte
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController carteController = TextEditingController();

  // 🎯 Gestion des erreurs
  String? usernameError;
  String? passwordError;
  String? nomError;
  String? prenomError;
  String? roleError;
  String? carteError;
  bool isLoading = false;

  // 📌 Validation des champs
  String? inputValidator(String input, String type) {
    if (type == 'username' && input.length < 3) {
      return "Nom d'utilisateur trop court";
    } else if (type == 'password' && input.length < 6) {
      return "Mot de passe trop court";
    } else if (type == 'nom' && input.isEmpty) {
      return "Le nom est requis";
    } else if (type == 'prenom' && input.isEmpty) {
      return "Le prénom est requis";
    } else if (type == 'role' && input.isEmpty) {
      return "Le rôle est requis";
    } else if (type == 'carte' && input.isEmpty) {
      return "L'ID de la carte est requis";
    }
    return null;
  }

  // 📌 Fonction pour ajouter un utilisateur
  Future<void> _handleAddUser() async {
    setState(() {
      isLoading = true;
    });

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final nom = nomController.text.trim();
    final prenom = prenomController.text.trim();
    final role = roleController.text.trim();
    final idCarte = carteController.text.trim();

    usernameError = inputValidator(username, 'username');
    passwordError = inputValidator(password, 'password');
    nomError = inputValidator(nom, 'nom');
    prenomError = inputValidator(prenom, 'prenom');
    roleError = inputValidator(role, 'role');
    carteError = inputValidator(idCarte, 'carte');

    if (usernameError != null ||
        passwordError != null ||
        nomError != null ||
        prenomError != null ||
        roleError != null ||
        carteError != null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await AuthenticationProvider().addUser(
        username,
        password,
        nom,
        prenom,
        role,
        idCarte,
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Utilisateur ajouté avec succès')),
        );
        Navigator.pop(context); // Retour à la page précédente
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un utilisateur'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(height: screenHeight * 0.05),
          Text(
            "Ajouter un nouvel utilisateur",
            style: GoogleFonts.archivoBlack(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.05),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: "Nom d'utilisateur",
              errorText: usernameError,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: nomController,
            decoration: InputDecoration(
              labelText: "Nom",
              errorText: nomError,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: prenomController,
            decoration: InputDecoration(
              labelText: "Prénom",
              errorText: prenomError,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Mot de passe",
              errorText: passwordError,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: roleController,
            decoration: InputDecoration(
              labelText: "ID Rôle (1:RH, 2:Développeur, 3:Administrateur)",
              errorText: roleError,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: carteController,
            decoration: InputDecoration(
              labelText: "ID Carte",
              errorText: carteError,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isLoading ? null : _handleAddUser,
            child: isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
                    "Ajouter l'utilisateur",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }
}
