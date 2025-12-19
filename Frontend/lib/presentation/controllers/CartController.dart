// cart_controller.dart
import 'package:flutter/material.dart';
import '../../data/cart_repository.dart';

class CartController with ChangeNotifier {
  final CartRepository repo;
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = false;

  CartController(this.repo);

  Future<void> fetchCart({int? userId, String? sessionId}) async {
    isLoading = true;
    notifyListeners();
    cartItems = await repo.fetchCart(userId: userId, sessionId: sessionId);
    isLoading = false;
    notifyListeners();
  }

  Future<void> addToCart({int? userId, String? sessionId, required int productId, int quantite = 1}) async {
    await repo.addToCart(userId: userId, sessionId: sessionId, productId: productId, quantite: quantite);
    await fetchCart(userId: userId, sessionId: sessionId);
  }

  Future<void> removeCartItem(int cardItemId, {int? userId, String? sessionId}) async {
    await repo.removeCartItem(cardItemId);
    await fetchCart(userId: userId, sessionId: sessionId);
  }
}
