import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constant.dart';
import '../shared_preferences/shared_preferences_helper.dart';

class FavoriRepository {
  final _client = http.Client();

  Future<List<Map<String, dynamic>>> fetchFavorites(int userId) async {
    final url = Uri.parse('${AppConstants.baseUrl}/favori/user/$userId'); // <-- FIXED
    final resp = await _client.get(url);
    if (resp.statusCode == 200) {
      final list = jsonDecode(resp.body) as List;
      return list.cast<Map<String, dynamic>>();
    }
    throw Exception('Erreur lecture favoris');
  }

  Future<void> addFavorite({required int userId, required int productId}) async {
    final url = Uri.parse('${AppConstants.baseUrl}/favori/add');
    final body = jsonEncode({'userId': userId, 'productId': productId});
    print('POST $url body=$body');

    final token = await SharedPreferencesHelper.getToken(); // récupère ton JWT ici
    final resp = await _client.post(url, headers: {
      'Content-Type': 'application/json',
      // Ajoute ton header d’auth ici si besoin :
       'Authorization': 'Bearer $token',
    }, body: body);
    print('Status: ${resp.statusCode} | Body: ${resp.body}');
    if (resp.statusCode != 200) {
      throw Exception('Erreur ajout favori');
    }
  }


  Future<void> removeFavorite({required int userId, required int productId}) async {
    final url = Uri.parse('${AppConstants.baseUrl}/favori/remove'); // <-- FIXED
    final body = jsonEncode({'userId': userId, 'productId': productId});
    final resp = await _client.delete(url, headers: {'Content-Type': 'application/json'}, body: body);
    if (resp.statusCode != 200) {
      throw Exception('Erreur suppression favori');
    }
  }
}
