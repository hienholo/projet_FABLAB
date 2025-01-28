import 'package:fablabs7/pages/dashboardPage.dart';
import 'package:fablabs7/pages/httpRequest.dart';
import 'package:fablabs7/pages/lockPage.dart';
import 'package:fablabs7/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sing_In extends StatefulWidget {
  const Sing_In({super.key});

  @override
  State<Sing_In> createState() => _Sing_InState();
}

class _Sing_InState extends State<Sing_In> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  String? emailError;
  String? passwordError;
  String? usernameError;
  bool isLoading = false;

  // Fonction de validation dynamique
  String? inputValidator(String input, String type) {
    if (type == 'email') {
      String pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(input)) {
        return "Email invalide";
      }
    } else if (type == 'password') {
      if (input.length < 3) {
        return "Mot de passe trop court";
      }
    }
    else if (type == 'username') {
      if (input.length < 3) {
        return "username trop court";
      }
    }
    return null;
  }

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true;
    });

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // Validation locale
    emailError = inputValidator(username, 'username');
    passwordError = inputValidator(password, 'password');

    if (emailError != null || passwordError != null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final token = await AuthenticationProvider().login(username, password);

      if (token != null) {
        final user = AuthenticationProvider.user;

        if (user?.role == 'admin') {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LockPage()),
          );
        }
      } else {
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de la connexion. Vérifiez vos identifiants.')),
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
      body: ListView(
        children: [
          SizedBox(height: screenHeight * 0.15),
          Center(
            child: Image.asset(
              "assets/images/smart-door-lock-100.png",
              height: 50,
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            "Smart Door",
            style: GoogleFonts.archivoBlack(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.09),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login Now",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: "username",
                      errorText: usernameError,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter Passcode",
                      errorText: passwordError,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isLoading ? null : _handleLogin,
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Login Now",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Action pour "Forgot Passcode"
                          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => DashboardPage()),
                        );
                        },
                        child: Text(
                          "Forgot Passcode",
                          style: TextStyle(
                            color: Colors.grey[600],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
