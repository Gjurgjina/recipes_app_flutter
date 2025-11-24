import 'package:flutter/material.dart';
import 'package:meals_app/models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      //widget sto reagira na dopir(klik)
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.network(
              category.thumb,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      category.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,//tri tocki na kraj ako ima uste tekst
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
