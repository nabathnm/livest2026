import 'package:flutter/material.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:livest/features/breader/marketplace/services/test_service.dart';

class TestProvider extends ChangeNotifier {
  final TestService _testService = TestService();

  List<ProductModel> _products = [];
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> getMyProduct(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _testService.getMyProduct(userId);
    } catch (e) {
      print("Error read: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createProduct(ProductModel product) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newProduct = await _testService.createProduct(product);
      _products.add(newProduct);
    } catch (e) {
      print("Error create: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProduct(ProductModel product) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedProduct = await _testService.updateProduct(product);

      final index = _products.indexWhere((p) => p.id == product.id);

      if (index != -1) {
        _products[index] = updatedProduct;
      }
    } catch (e) {
      print("Error update: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteProduct(int productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _testService.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
    } catch (e) {
      print("Error delete: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
