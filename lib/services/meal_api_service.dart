import 'dart:convert';

import 'package:meals_app/models/meal_from_category.dart';
import 'package:meals_app/models/meal_detail.dart';

import '../models/category.dart';
import 'package:http/http.dart' as http;

//API povici kon internet
class MealApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  
  Future<List<Category>> fetchCategories() async {
    final uri = Uri.parse('$baseUrl/categories.php');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      //pretvori go json vo dart map
      final data = jsonDecode(response.body);
      final List categoriesJson = data['categories'];
      return categoriesJson
          .map((json) => Category.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }

  
  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final uri = Uri.parse('$baseUrl/filter.php?c=$category');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List mealsJson = data['meals'] ?? [];
      return mealsJson
          .map((json) => Meal.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load meals for category");
    }
  }

  
  Future<List<Meal>> searchMealsInCategory(String category, String query) async {
    final uri = Uri.parse('$baseUrl/search.php?s=$query');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List? mealsJson = data['meals'];
      if (mealsJson == null) return [];
      
      return mealsJson
          .where((m) => m['strCategory'] == category)
          .map<Meal>((json) => Meal.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to search meals");
    }
  }

  //vrakja cel repect so sostojki
  Future<MealDetail> getMealDetail(String id) async {
    final uri = Uri.parse('$baseUrl/lookup.php?i=$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List mealsJson = data['meals'] ?? [];
      return MealDetail.fromJson(mealsJson.first);
    } else {
      throw Exception("Failed to load meal detail");
    }
  }

  //vrakja random recept
  Future<MealDetail> getRandomMeal() async {
    final uri = Uri.parse('$baseUrl/random.php');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List mealsJson = data['meals'] ?? [];
      return MealDetail.fromJson(mealsJson.first);
    } else {
    throw Exception("Failed to load random meal");
    }
  }
}
