import 'package:flutter/material.dart';
import 'package:meals_app/models/meal_detail.dart';
import 'package:meals_app/services/meal_api_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final MealApiService apiService;

  const MealDetailScreen({
    super.key,
    required this.mealId,
    required this.apiService,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late Future<MealDetail> _mealFuture;

  @override
  void initState() {
    super.initState();
    _mealFuture = widget.apiService.getMealDetail(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe detail"),
        backgroundColor: Colors.orange.shade50,
      ),
      body: FutureBuilder<MealDetail>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final meal = snapshot.data!;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(meal.thumbnail),
                SizedBox(height: 16),
                Text(
                  meal.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('${meal.category} • ${meal.area}'),
                SizedBox(height: 16),
                Text(
                  "Ingredisents:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ...meal.ingredients.map(
                  (ing) => Text("• ${ing.name} - ${ing.measure}"),
                ),
                SizedBox(height: 16),
                Text(
                  "Instructions:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(meal.instructions),
                SizedBox(height: 16),
                if (meal.youtubeUrl.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "YouTube:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      SelectableText(
                        meal.youtubeUrl,
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
