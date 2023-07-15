import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];

  List<ProductModel> get products => _products;
  bool loading = false;

  Future<void> fetchProducts() async {
    loading = true;
    try {
      final response =
          await http.get(Uri.parse("https://fakestoreapi.com/products"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _products = data.map((e) => ProductModel.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      print(e);
    } finally {
      loading = false;
    }
  }

  delete(int index) {
    _products.removeAt(index);
    notifyListeners();
  }
}
