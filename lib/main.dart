import 'package:flutter/material.dart';
import 'package:meals_app/screens/home.dart';
import 'package:meals_app/services/meal_api_service.dart';

// main.dart -> start na aplikacijata
void main() {
  runApp(const MyRecipesApp());
}

class MyRecipesApp extends StatelessWidget {
  const MyRecipesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mealApiService = MealApiService();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {"/": (context) => MyHomePage(mealApiService: mealApiService)},
    );
  }
}
