import 'package:flutter/material.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/services/meal_api_service.dart';
import 'package:meals_app/widgets/category_card.dart';

import 'meal_details.dart';
import 'meals_by_category_screen.dart';

class MyHomePage extends StatefulWidget {
  final MealApiService mealApiService;

  const MyHomePage({super.key, required this.mealApiService});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Category>> categoriesFuture;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    categoriesFuture = widget.mealApiService.fetchCategories();
  }

  void _openRandomMeal() async {
    final randomMeal = await widget.mealApiService.getRandomMeal();
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(
          mealId: randomMeal.id,
          apiService: widget.mealApiService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade50,
        title: const Text('Recipe Categories'),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  // search bar background
                  labelText: 'Search categories',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  prefixIcon: Icon(Icons.search, color: Colors.orange.shade800),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, // no border
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Category>>(
              future: categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final categories = snapshot.data ?? [];

                final filtered = categories.where((c) {
                  if (searchQuery.isEmpty) return true;
                  return c.name.toLowerCase().contains(searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No categories found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final category = filtered[index];

                    return CategoryCard(
                      category: category,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MealsByCategoryScreen(
                              categoryName: category.name,
                              apiService: widget.mealApiService,
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
      ),
    );
  }
}
