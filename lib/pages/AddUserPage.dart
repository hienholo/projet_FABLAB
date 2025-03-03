import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fablabs7/pages/httpRequest.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  int? selectedCarte ;
  DateTime? dateDebut;
  DateTime? dateFin;
  int? selectedRole;
  bool desactive = false;

  String? usernameError;
  String? passwordError;
  String? nomError;
  String? prenomError;
  String? carteError;
  bool isLoading = false;

  final List<Map<String, dynamic>> roles = [
    {'id': 1, 'name': 'RH'},
    {'id': 2, 'name': 'Développeur'},
    {'id': 3, 'name': 'Administrateur'},
  ];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          dateDebut = picked;
        } else {
          dateFin = picked;
        }
      });
    }
  }

  Future<void> _handleAddUser() async {
    setState(() {
      isLoading = true;
    });

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final nom = nomController.text.trim();
    final prenom = prenomController.text.trim();
    final idCarte = selectedCarte.toString();
    final role = selectedRole;
    final debut = dateDebut != null ? DateFormat('yyyy-MM-dd').format(dateDebut!) : null;
    final fin = dateFin != null ? DateFormat('yyyy-MM-dd').format(dateFin!) : null;

    if (username.isEmpty || username.length < 3) {
      setState(() => usernameError = "Nom d'utilisateur trop court");
    } else {
      usernameError = null;
    }

    if (password.isEmpty || password.length < 6) {
      setState(() => passwordError = "Mot de passe trop court");
    } else {
      passwordError = null;
    }

    if (nom.isEmpty) {
      setState(() => nomError = "Le nom est requis");
    } else {
      nomError = null;
    }

    if (prenom.isEmpty) {
      setState(() => prenomError = "Le prénom est requis");
    } else {
      prenomError = null;
    }

    if (idCarte.isEmpty) {
      setState(() => carteError = "L'ID de la carte est requis");
    } else {
      carteError = null;
    }

    if (usernameError != null || passwordError != null || nomError != null || prenomError != null || carteError != null) {
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
        debut.toString(),
        fin.toString(),
        role.toString(),
        idCarte,
        "add"
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utilisateur ajouté avec succès')),
        );
        Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un utilisateur'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(labelText: "Nom d'utilisateur", errorText: usernameError),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: nomController,
                  decoration: InputDecoration(labelText: "Nom", errorText: nomError),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: prenomController,
                  decoration: InputDecoration(labelText: "Prénom", errorText: prenomError),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Mot de passe", errorText: passwordError),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: "Rôle"),
            value: selectedRole,
            items: roles.map((role) {
              return DropdownMenuItem<int>(
                value: role['id'],
                child: Text(role['name']),
              );
            }).toList(),
            onChanged: (value) => setState(() => selectedRole = value),
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: "ID carte"),
            value: selectedCarte,
            items: roles.map((role) {
              return DropdownMenuItem<int>(
                value: role['id'],
                child: Text(role['name']),
              );
            }).toList(),
            onChanged: (value) => setState(() => selectedRole = value),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _selectDate(context, true),
            child: Text(dateDebut == null ? "Sélectionner Date Début" : "Début: ${DateFormat('dd/MM/yyyy').format(dateDebut!)}"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _selectDate(context, false),
            child: Text(dateFin == null ? "Sélectionner Date Fin" : "Fin: ${DateFormat('dd/MM/yyyy').format(dateFin!)}"),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isLoading ? null : _handleAddUser,
            child: isLoading ? const CircularProgressIndicator() : const Text("Ajouter l'utilisateur"),
          ),
        ],
      ),
    );
  }
}
