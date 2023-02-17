class Product {
  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.rating,
    this.count,
  });

  int id;
  String title;
  String image;
  double price;
  dynamic rating;
  int? count = 0;

  Map<String, dynamic> toJson() => {
        "title": title,
        "image": image,
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      price: json['price'].toDouble(),
      rating: json['rating'],
    );
  }
}
