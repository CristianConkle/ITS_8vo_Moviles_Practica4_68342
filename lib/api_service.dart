import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final String _apiUrl = dotenv.get('API_URL');

  // Obtener headers con token desde SharedPreferences
  static Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$_apiUrl/tareas'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar las tareas');
    }
  }

  static Future<Map<String, dynamic>> getTaskById(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$_apiUrl/tareas/$id'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar la tarea');
    }
  }

  static Future<Map<String, dynamic>> createTask(
    Map<String, dynamic> task,
  ) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_apiUrl/tareas'),
      headers: headers,
      body: json.encode(task),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Error al crear la tarea');
    }
  }

  static Future<Map<String, dynamic>> updateTask(
    int id,
    Map<String, dynamic> task,
  ) async {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      Uri.parse('$_apiUrl/tareas/$id'),
      headers: headers,
      body: json.encode(task),
    );
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar la tarea');
    }
  }

  static Future<Map<String, dynamic>> toggleTaskCompletion(
    int id,
    bool completed,
  ) async {
    final headers = await _getAuthHeaders();
    final response = await http.patch(
      Uri.parse('$_apiUrl/tareas/$id'),
      headers: headers,
      body: json.encode({'completada': completed}),
    );
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar la tarea');
    }
  }

  static Future<void> deleteTask(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$_apiUrl/tareas/$id'),
      headers: headers,
    );
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la tarea');
    }
  }
}
