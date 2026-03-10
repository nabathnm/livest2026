import 'package:flutter/material.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:livest/features/buyer/cart/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  List<ProductModel> _cartItems = [];
  bool _isLoading = false;

  List<ProductModel> get cartItems => _cartItems;
  bool get isLoading => _isLoading;

  /// Load cart
  Future<void> loadCart(String userId) async {
    _isLoading = true;
    notifyListeners();

    _cartItems = await _cartService.getCartItems(userId);

    _isLoading = false;
    notifyListeners();
  }

  /// Add to cart
  Future<void> addToCart(String userId, ProductModel product) async {
    await _cartService.addToCart(userId, product.id!);

    _cartItems.add(product);
    notifyListeners();
  }

  /// Remove from cart
  Future<void> removeFromCart(String userId, ProductModel product) async {
    await _cartService.removeFromCart(userId, product.id!);

    _cartItems.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  /// Check product in cart (local state)
  bool isInCart(int productId) {
    return _cartItems.any((item) => item.id == productId);
  }

  int get cartCount => _cartItems.length;
}
