class Product {
  final String id;
  final String collectionId;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.collectionId,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      collectionId: json['collectionId'],
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
}
