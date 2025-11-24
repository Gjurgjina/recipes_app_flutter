
class Category {
  final String id;
  final String name;
  final String thumb;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.thumb,
    required this.description,
  });

  //factory e specijalen konstruktor, za da se kreira objekt od json
  //fromJson -> cita JSON od API i go pretvora vo Category object
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json["idCategory"],
        name: json["strCategory"],
        thumb: json["strCategoryThumb"],
        description: json["strCategoryDescription"],
    );
  }
}
