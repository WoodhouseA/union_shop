class Product {
  final String id;
  final String collectionId;
  final String name;
  final double price;
  final bool onSale;
  final double? salePrice;
  final String imageUrl;
  final List<String> sizes;
  final List<String> colors;

  Product({
    required this.id,
    required this.collectionId,
    required this.name,
    required this.price,
    required this.onSale,
    this.salePrice,
    required this.imageUrl,
    required this.sizes,
    required this.colors,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      collectionId: json['collectionId'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      onSale: json['onSale'] ?? false,
      salePrice: (json['salePrice'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'],
      sizes: List<String>.from(json['sizes']),
      colors: List<String>.from(json['colors']),
    );
  }
}
