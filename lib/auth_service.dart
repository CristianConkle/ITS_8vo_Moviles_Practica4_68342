import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final String _apiUrl = dotenv.get('API_URL');
  static String? _token;

  static String? get token => _token;

  // 🔹 Inicializar desde SharedPreferences
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  // 🔹 Método para iniciar sesión
  static Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  // 🔹 Método para registrar un usuario
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

  // 🔹 Método para cerrar sesión
  static Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
