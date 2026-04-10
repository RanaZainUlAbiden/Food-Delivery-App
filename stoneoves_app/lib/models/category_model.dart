class CategoryModel {
  final int id;
  final String name;
  final String? image;
  final int sortOrder;

  CategoryModel({
    required this.id,
    required this.name,
    this.image,
    required this.sortOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      sortOrder: json['sortOrder'],
    );
  }
}