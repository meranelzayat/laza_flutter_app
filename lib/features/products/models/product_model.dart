class Product {
  final int id;
  final String title;
  final int price;
  final String description;
  final List<String> images;

  // category
  final String categoryName;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    required this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final imgs =
        (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [];

    final category = json['category'];
    final catName = category is Map<String, dynamic>
        ? (category['name']?.toString() ?? '')
        : '';

    return Product(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      price: (json['price'] as num).toInt(),
      description: json['description']?.toString() ?? '',
      images: imgs,
      categoryName: catName,
    );
  }

  String get firstImage {
    if (images.isEmpty) return '';
    return images.first;
  }
}
