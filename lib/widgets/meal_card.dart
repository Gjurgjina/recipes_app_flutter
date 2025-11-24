import 'package:flutter/material.dart';

import '../models/meal_from_category.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealCard({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Image.network(
                    meal.thumbnail,
                    fit: BoxFit.cover
                ),
            ),

            Container(
              width: double.infinity,
              color: Colors.orange.shade50,
              padding: EdgeInsets.all(8),
              child: Text(
                textAlign: TextAlign.center,
                meal.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
