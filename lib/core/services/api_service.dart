import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/product_model.dart';

abstract final class ApiService {
  static const _connectPath = '/VenusRetail/api/connect';
  static const _selectDataPath = '/VenusRetail/api/selectData';

  static Future<ConnectResult> connect(String serverUrl) async {
    final url = Uri.parse('http://$serverUrl$_connectPath');
    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'dbName': serverUrl}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return ConnectResult(
        success: true,
        message: body['message']?.toString() ?? 'Terhubung',
      );
    }

    return ConnectResult(
      success: false,
      message: 'Gagal terhubung ke server',
    );
  }

  static Future<List<ProductModel>> fetchProduct({
    required String serverUrl,
    required String barcode,
  }) async {
    final url = Uri.parse('http://$serverUrl$_selectDataPath');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'kode': barcode}),
    );

    if (response.statusCode != 200) {
      throw ApiException('Server error: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) return [];

    return decoded
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

class ConnectResult {
  const ConnectResult({required this.success, required this.message});

  final bool success;
  final String message;
}

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
