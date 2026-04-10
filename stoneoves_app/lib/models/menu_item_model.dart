class MenuItemModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? image;
  final String? tag;
  final bool isAvailable;
  final int categoryId;
  final String categoryName;

  MenuItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.image,
    this.tag,
    required this.isAvailable,
    required this.categoryId,
    required this.categoryName,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      tag: json['tag'],
      isAvailable: json['isAvailable'],
      categoryId: json['categoryId'],
      categoryName: json['category']['name'],
    );
  }
}