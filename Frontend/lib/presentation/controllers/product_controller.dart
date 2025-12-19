import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/product_repository.dart';

class ProductController with ChangeNotifier {
  final ProductRepository repo;
  List<Map<String, dynamic>> products = [];
  bool isLoading = false;
  String? error;

  ProductController(this.repo);

  Future<void> loadProducts(String coopEmail) async {
    isLoading = true; error = null; notifyListeners();
    try {
      products = await repo.fetchProductsByCoop(coopEmail);
    } catch (e) {
      error = e.toString();
    }
    isLoading = false; notifyListeners();
  }

  Future<void> addProduct({
    required String coopEmail,
    required String nom,
    required String description,
    required double prix,
    List<File>? images = const [],
  }) async {
    await repo.addProduct(
      coopEmail: coopEmail, nom: nom, description: description, prix: prix, images: images,
    );
    // Reload products
    await loadProducts(coopEmail);
  }

  Future<void> deleteProduct(String coopEmail, String nom) async {
    await repo.deleteProduct(coopEmail, nom);
    await loadProducts(coopEmail);
  }

  List<Map<String, dynamic>> allProducts = [];
  bool isLoadingAll = false;

  Future<void> loadAllProducts() async {
    isLoadingAll = true;
    notifyListeners();
    try {
      allProducts = await repo.fetchAllProducts();
    } catch (e) {
      allProducts = [];
    }
    isLoadingAll = false;
    notifyListeners();
  }

  // ---------- NEW: Fetch single product by id ----------
  Future<Map<String, dynamic>> fetchProductById(int id) async {
    return await repo.fetchProductById(id);
  }
}
