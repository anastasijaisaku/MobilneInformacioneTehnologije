import 'package:biblioteka/models/categories_model.dart';
import 'package:biblioteka/services/assets_manager.dart';

class AppConstants {
  static const String imageUrl =
      'https://m.media-amazon.com/images/I/71nj3JM-igL._AC_UF894,1000_QL80_.jpg';

  static List<String> bannersImages = [
    "${AssetsManager.imagePath}/banners/biblioteka1.jpg",
    "${AssetsManager.imagePath}/banners/biblioteka2.jpg",
  ];

  // KATEGORIJE
  static List<CategoriesModel> categoriesList = [
    CategoriesModel(
      id: "textbooks",
      name: "Udžbenici",
      image: "${AssetsManager.imagePath}/categories/book.png",
    ),
    CategoriesModel(
      id: "fiction",
      name: "Romani",
      image: "${AssetsManager.imagePath}/categories/book.png",
    ),
    CategoriesModel(
      id: "professional",
      name: "Stručna literatura",
      image: "${AssetsManager.imagePath}/categories/book.png",
    ),
    CategoriesModel(
      id: "children",
      name: "Dečije knjige",
      image: "${AssetsManager.imagePath}/categories/book.png",
    ),
  ];
}
