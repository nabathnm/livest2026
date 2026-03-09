import 'package:flutter/material.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import '../services/buyer_marketplace_service.dart';

class BuyerMarketplaceProvider extends ChangeNotifier {
  final BuyerMarketplaceService _service = BuyerMarketplaceService();

  List<ProductModel> products = [];
  bool isLoading = false;

  Object? get sellerProducts => null;

  Future<void> getProducts() async {
    isLoading = true;
    notifyListeners();

    try {
      products = await _service.getProduct();
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}
