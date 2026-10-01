import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/recipe.dart';

class ApiService {
  // Base URL configuration for standard local development
  // 10.0.2.2 for Android Emulator, 127.0.0.1 for Desktop/Web/iOS Simulator
  static String get defaultBaseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000';
    }
    return 'http://127.0.0.1:5000';
  }

  static String baseUrl = defaultBaseUrl;

  /// GET /api/ingredientes/sugeridos
  static Future<List<String>> getSuggestedIngredients() async {
    final url = Uri.parse('$baseUrl/api/ingredientes/sugeridos');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['ingredientes'] != null) {
          return List<String>.from(data['ingredientes']);
        }
      }
      throw Exception('Código de respuesta no válido: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error obteniendo sugerencias: $e');
      // Fallback local list in case backend is offline
      return [
        'Tomate',
        'Cebolla',
        'Huevo',
        'Arroz',
        'Pollo',
        'Queso',
        'Papa',
        'Zanahoria',
        'Leche',
        'Ajo',
        'Pimiento',
        'Espinaca',
        'Pan',
        'Atún'
      ];
    }
  }

  /// POST /api/receta/generar
  static Future<Recipe> generateRecipe(List<String> ingredients) async {
    final url = Uri.parse('$baseUrl/api/receta/generar');
    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'ingredientes': ingredients}),
        )
        .timeout(const Duration(seconds: 25));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return Recipe.fromJson(data);
    } else {
      final errorData = json.decode(utf8.decode(response.bodyBytes));
      throw Exception(
          errorData['mensaje'] ?? 'Error del servidor (${response.statusCode})');
    }
  }

  /// PUT /api/historial/favorito
  static Future<Recipe> updateFavorite(int recipeId, bool isFavorite) async {
    final url = Uri.parse('$baseUrl/api/historial/favorito');
    final response = await http
        .put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'id': recipeId, 'favorito': isFavorite}),
        )
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return Recipe.fromJson(data['receta']);
    } else {
      throw Exception('Error al actualizar favorito: ${response.statusCode}');
    }
  }

  /// DELETE /api/historial/id
  static Future<bool> deleteRecipe(int recipeId) async {
    final url = Uri.parse('$baseUrl/api/historial/$recipeId');
    final response = await http
        .delete(url)
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Error al eliminar receta (${response.statusCode})');
    }
  }

  /// GET /api/historial
  static Future<List<Recipe>> getHistory() async {
    final url = Uri.parse('$baseUrl/api/historial');
    final response = await http.get(url).timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final List recipesList = data['recetas'] ?? [];
      return recipesList.map((e) => Recipe.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener historial');
    }
  }
}
