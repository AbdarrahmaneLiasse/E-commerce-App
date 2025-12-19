// cart_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constant.dart';

class CartRepository {
  final _client = http.Client();

  Future<void> addToCart({int? userId, String? sessionId, required int productId, required int quantite}) async {
    final url = Uri.parse('${AppConstants.baseUrl}/cart/add');
    final body = jsonEncode({
      'userId': userId,
      'sessionId': sessionId,
      'productId': productId,
      'quantite': quantite,
    });
    final response = await _client.post(url, headers: {'Content-Type': 'application/json'}, body: body);
    if (response.statusCode != 200) {
      throw Exception('Echec ajout panier');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCart({int? userId, String? sessionId}) async {
    final url = Uri.parse('${AppConstants.baseUrl}/cart?userId=${userId ?? ""}&sessionId=${sessionId ?? ""}');
    final resp = await _client.get(url);
    if (resp.statusCode == 200) {
      final list = jsonDecode(resp.body) as List;
      return list.cast<Map<String, dynamic>>();
    }
    throw Exception('Erreur lecture panier');
  }

  Future<void> removeCartItem(int cardItemId) async {
    final url = Uri.parse('${AppConstants.baseUrl}/cart/$cardItemId');
    final resp = await _client.delete(url);
    if (resp.statusCode != 200) {
      throw Exception('Erreur suppression article');
    }
  }
}
