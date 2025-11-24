//Detalen recept + sostojki

class Ingredient {
  final String name;
  final String measure;

  Ingredient({required this.name, required this.measure});
}

class MealDetail {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String youtubeUrl;
  final List<Ingredient> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtubeUrl,
    required this.ingredients,
  });

  //pretvora JSON od Api vo Dart objekt
  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final List<Ingredient> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json["strIngredient$i"];
      final measure = json["strMeasure$i"];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(
          Ingredient(
            name: ingredient.toString(),
            measure: (measure ?? '').toString(),//ako merkata e null stava prazno
          ),
        );
      }
    }
    return MealDetail(
      id: json["idMeal"],
      name: json["strMeal"],
      category: json["strCategory"] ?? '',
      area: json["strArea"] ?? '',
      instructions: json["strInstructions"] ?? '',
      thumbnail: json["strMealThumb"] ?? '',
      youtubeUrl: json["strYoutube"] ?? '',
      ingredients: ingredients,
    );
  }
}
