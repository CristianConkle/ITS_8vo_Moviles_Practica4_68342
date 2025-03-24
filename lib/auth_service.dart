import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final String _apiUrl = dotenv.get('API_URL');

  // Iniciar sesión
  static Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  // Registro de usuario
  static Future<void> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al registrar usuario');
    }
  }

  // Obtener token actual
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  //  Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
