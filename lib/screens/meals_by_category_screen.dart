import 'package:flutter/material.dart';

import '../models/meal_from_category.dart';
import '../services/meal_api_service.dart';
import '../widgets/meal_card.dart';
import 'meal_details.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String categoryName;
  final MealApiService apiService;

  const MealsByCategoryScreen({
    super.key,
    required this.categoryName,
    required this.apiService,
  });

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  late Future<List<Meal>> _mealsFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _mealsFuture = widget.apiService.fetchMealsByCategory(widget.categoryName);
  }

  Future<void> _loadMeals() async {
    setState(() {
      if (_searchQuery.isEmpty) {
        _mealsFuture = widget.apiService.fetchMealsByCategory(
          widget.categoryName,
        );
      } else {
        _mealsFuture = widget.apiService.searchMealsInCategory(
          widget.categoryName,
          _searchQuery,
        );
      }
    });
  }

  void _openRandomMeal() async {
    final randomMeal = await widget.apiService.getRandomMeal();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            MealDetailScreen(
              mealId: randomMeal.id,
              apiService: widget.apiService,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade50,
        title: Text(widget.categoryName),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino),
            tooltip: 'Random recipe',
            onPressed: _openRandomMeal,
          ),
        ],
      ),
      body: Column(
        children: [
      Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10, // softness
              offset: Offset(0, 4), // shadow position
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: 'Search meals',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.search,color: Colors.orange),
          ),
          onChanged: (value) {
            _searchQuery = value;
            _loadMeals();
          },
        ),
      ),
      ),
      Expanded(
        child: FutureBuilder<List<Meal>>(
          future: _mealsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final meals = snapshot.data ?? [];

            if (meals.isEmpty) {
              return const Center(child: Text('No meals found.'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return MealCard(
                  meal: meal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MealDetailScreen(
                              mealId: meal.id,
                              apiService: widget.apiService,
                            ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      ],
    ),);
  }
}
