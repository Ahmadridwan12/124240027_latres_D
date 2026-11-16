class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.sku,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.returnPolicy,
    required this.thumbnail,
    required this.images,
    required this.tags,
    required this.reviews,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String sku;
  final String warrantyInformation;
  final String shippingInformation;
  final String returnPolicy;
  final String thumbnail;
  final List<String> images;
  final List<String> tags;
  final List<ProductReview> reviews;

  factory Product.fromJson(Map<String, dynamic> json) {
    final reviewData = json['reviews'] as List<dynamic>? ?? const [];
    return Product(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Produk',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] as num? ?? 0).toDouble(),
      rating: (json['rating'] as num? ?? 0).toDouble(),
      stock: json['stock'] as int? ?? 0,
      brand: json['brand'] as String? ?? '-',
      sku: json['sku'] as String? ?? '-',
      warrantyInformation: json['warrantyInformation'] as String? ?? '-',
      shippingInformation: json['shippingInformation'] as String? ?? '-',
      returnPolicy: json['returnPolicy'] as String? ?? '-',
      thumbnail: json['thumbnail'] as String? ?? '',
      images: (json['images'] as List<dynamic>? ?? const []).cast<String>(),
      tags: (json['tags'] as List<dynamic>? ?? const []).cast<String>(),
      reviews: reviewData
          .map(
            (review) => ProductReview.fromJson(review as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class ProductReview {
  const ProductReview({
    required this.rating,
    required this.comment,
    required this.reviewerName,
  });

  final int rating;
  final String comment;
  final String reviewerName;

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      reviewerName: json['reviewerName'] as String? ?? 'Anonim',
    );
  }
}
