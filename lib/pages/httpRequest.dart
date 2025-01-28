import 'dart:convert';
import 'package:fablabs7/constaints.dart';
import 'package:fablabs7/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider {
  static String? _token;
  static UserModel? _user;

  static String? get token => _token;

  static UserModel? get user => _user;

  bool get isAuthenticated => _token != null;

  static void setUser(UserModel user) {
    _user = user;
  }

  Future<String?> login(String username, String password) async {
    try {
      dynamic response = await makeAuthenticationRequest(username, password);
      _token = response['token'];
      print('_token = ' + _token!);
    } catch (error) {
      print("Login error: $error");
      return null;
    }
    return _token;
  }

  Future<dynamic> makeAuthenticationRequest(String username, String password) async {
    final response = await http.post(
      Uri.parse(server + 'login'),
      headers: <String, String>{
        "Content-Type": "application/json",
      },
      body: jsonEncode(<String, String>{"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final responseResult = jsonDecode(response.body);
      return responseResult;
    } else {
      // Handling the error from the server response
      final responseResult = jsonDecode(response.body);
      throw Exception('Failed to authenticate: ${responseResult['error']}');
    }
  }

  
Future<Map<String, dynamic>> addUser(
  String username,
  String password,
  String nom,
  String prenom,
  String role,
  String idCarte,
) async {
  final response = await http.post(
    Uri.parse('http://192.168.221.249:3000/users/add'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'password': password,
      'nom': nom,
      'prenom': prenom,
      'id_role': role,
      'id_carte': idCarte,
      'date_debut': DateTime.now().toIso8601String(),
    }),
  );

  return jsonDecode(response.body);
}


  static void logout() {
    // Clear the stored token
    _token = null;
  }
}
