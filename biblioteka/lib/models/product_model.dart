class ProductModel {
  final String productId;
  final String productTitle;
  final String productPrice;
  final String productCategory;
  final String productDescription;
  final String productImage;
  final String productQuantity;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
  });

  factory ProductModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ProductModel(
      productId: docId,
      productTitle: (data['title'] ?? '').toString(),
      productPrice: (data['price'] ?? '').toString(),
      productCategory: (data['category'] ?? '').toString(),
      productDescription: (data['description'] ?? '').toString(),
      productImage: (data['imageUrl'] ?? '').toString(),
      productQuantity: (data['quantity'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "title": productTitle,
      "price": productPrice,
      "category": productCategory,
      "description": productDescription,
      "imageUrl": productImage,
      "quantity": productQuantity,
    };
  }
}
