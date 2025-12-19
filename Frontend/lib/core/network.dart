import 'package:http/http.dart' as http;

class Network {
  static final http.Client client = http.Client();

  static Future<http.Response> postMultipart({
    required String url,
    required Map<String, String> fields,
    Map<String, String>? headers, // Pas besoin du Content-Type ici
    List<http.MultipartFile>? files,
  }) async {
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll(fields);

    // Attention : N'AJOUTE PAS Content-Type ici !
    if (headers != null) {
      // Supprime explicitement tout Content-Type du header, si présent
      headers.removeWhere((k, v) => k.toLowerCase() == 'content-type');
      request.headers.addAll(headers);
    }

    if (files != null) request.files.addAll(files);

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
