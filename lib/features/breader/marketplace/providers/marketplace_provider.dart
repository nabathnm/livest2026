import 'package:flutter/material.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:livest/features/breader/marketplace/repository/marketplace_repository.dart';

class MarketplaceProvider extends ChangeNotifier {
  final MarketplaceRepository _marketplaceRepository = MarketplaceRepository();

  List<ProductModel> _products = [];
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  int get productCount => _products.length;

  double get totalSoldPrice {
    return _products
        .where((product) => product.isSold == true)
        .fold(0.0, (sum, product) => sum + (product.price ?? 0));
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> getMyProduct(String userId) async {
    _setLoading(true);
    try {
      _products = await _marketplaceRepository.getMyProduct(userId);
    } catch (e) {
      print("Error read: $e");
    }
    _setLoading(false);
  }

  Future<void> createProduct(ProductModel product) async {
    _setLoading(true);

    try {
      final newProduct = await _marketplaceRepository.createProduct(product);
      _products.add(newProduct);
    } catch (e) {
      print("Error create: $e");
    }
    _setLoading(false);
  }

  Future<void> updateProduct(ProductModel product) async {
    _setLoading(true);

    try {
      final updatedProduct = await _marketplaceRepository.updateProduct(
        product,
      );
      final index = _products.indexWhere((p) => p.id == product.id);

      if (index != -1) {
        _products[index] = updatedProduct;
      }
    } catch (e) {
      print("Error update: $e");
    }

    _setLoading(false);
  }

  Future<void> deleteProduct(int productId) async {
    _setLoading(true);

    try {
      await _marketplaceRepository.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
    } catch (e) {
      print("Error delete: $e");
    }

    _setLoading(false);
  }

  Future<void> markAsSold(int productId) async {
    await _marketplaceRepository.markAsSold(productId);

    final index = _products.indexWhere((p) => p.id == productId);

    if (index != -1) {
      _products[index] = _products[index].copyWith(isSold: true);
      notifyListeners();
    }
  }
}
