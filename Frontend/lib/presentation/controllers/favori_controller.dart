import 'package:flutter/material.dart';
import '../../data/favori_repository.dart';

class FavoriController with ChangeNotifier {
  final FavoriRepository repo;
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = false;

  FavoriController(this.repo);

  List<Map<String, dynamic>> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> fetchFavorites({required int userId}) async {
    _isLoading = true;
    notifyListeners();
    _favorites = await repo.fetchFavorites(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeFavorite({required int userId, required int productId}) async {
    await repo.removeFavorite(userId: userId, productId: productId);
    _favorites.removeWhere((item) => item['id'] == productId);
    notifyListeners();
  }

  bool isFavori(int productId) {
    return _favorites.any((item) => item['id'] == productId);
  }

  Future<void> toggleFavori(int userId, int productId, Map<String, dynamic> product) async {
    if (isFavori(productId)) {
      await removeFavorite(userId: userId, productId: productId);
    } else {
      await repo.addFavorite(userId: userId, productId: productId);
    }
    // Always re-fetch to ensure UI is in sync with server
    await fetchFavorites(userId: userId);
  }

}
