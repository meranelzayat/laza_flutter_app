import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ApiService {
  static const String _baseUrl = 'https://api.escuelajs.co/api/v1';

  Future<List<Product>> getProducts() async {
    final url = Uri.parse('$_baseUrl/products');

    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception('Failed to load products: ${res.statusCode}');
    }

    final data = jsonDecode(res.body);

    if (data is! List) {
      throw Exception('Unexpected response format');
    }

    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
