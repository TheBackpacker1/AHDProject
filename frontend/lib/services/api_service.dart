import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:5000/api/users";

  // Méthode pour la connexion
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    // Logs pour le débogage
    print("Request Body: ${jsonEncode({'email': email, 'password': password})}");
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Retourne les données de l'utilisateur
    } else if (response.statusCode == 401) {
      throw Exception('Invalid credentials'); // Erreur de connexion
    } else {
      throw Exception('Failed to login: ${response.body}'); // Autre erreur
    }
  }

  // Méthode pour ajouter un utilisateur
  static Future<Map<String, dynamic>> addUser(Map<String, String> user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user),
    );

    // Logs pour le débogage
    print("Request Body: ${jsonEncode(user)}");
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 201) {
      return jsonDecode(response.body); // Utilisateur ajouté avec succès
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: ${response.body}'); // Erreur de validation
    } else {
      throw Exception('Failed to add user: ${response.body}'); // Autre erreur
    }
  }

  // Méthode pour récupérer la liste des utilisateurs
  static Future<List<dynamic>> getUsers() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
    );

    // Logs pour le débogage
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Retourne la liste des utilisateurs
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }
}
