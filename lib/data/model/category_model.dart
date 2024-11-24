

class CategoryModel {
  final int id;
  final String name;

  CategoryModel(this.id, this.name);

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        json["id"],
        json["name"],
      );
}
