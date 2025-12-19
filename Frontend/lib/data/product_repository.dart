import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constant.dart';

class ProductRepository {
  final _client = http.Client();

  Future<List<Map<String, dynamic>>> fetchProductsByCoop(String emailCoop) async {

    final url = Uri.parse('${AppConstants.baseUrl}/products/by-coop/$emailCoop');
    final response = await _client.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<void> addProduct({
    required String coopEmail,
    required String nom,
    required String description,
    required double prix,
    List<File>? images,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/products/add');
    var request = http.MultipartRequest('POST', url);
    request.fields['data'] = jsonEncode({
      "coop_email": coopEmail,
      "nom": nom,
      "description": description,
      "prix": prix,
    });

    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt_token');
    if (jwt != null) {
      request.headers['Authorization'] = 'Bearer $jwt';
    }

    if (images != null && images.isNotEmpty) {
      for (var img in images) {
        request.files.add(await http.MultipartFile.fromPath('images', img.path));
      }
    } else {
      // Ajoute un dummy (ou laisse vide, Spring gère car required=false)
      // Si le backend pète sans, alors ajoute :
      // request.fields['images'] = '';
    }

    print('BODY: ${request.fields}');
    print('BODY: ${request.files}');
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Echec ajout produit: ${response.body}');
    }
  }

  Future<void> deleteProduct(String coopEmail, String nom) async {
    final url = Uri.parse('${AppConstants.baseUrl}/products/delete');
    final resp = await _client.delete(url, body: jsonEncode({
      'coop_email': coopEmail,
      'nom': nom,
    }), headers: {'Content-Type': 'application/json'});
    if (resp.statusCode != 200) {
      throw Exception('Suppression échouée');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    final url = Uri.parse('${AppConstants.baseUrl}/products/all');
    final response = await _client.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch all products');
    }
  }

  Future<Map<String, dynamic>> fetchProductById(int id) async {
    final url = Uri.parse('${AppConstants.baseUrl}/products/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Produit non trouvé');
    }
  }

}
