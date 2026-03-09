import 'package:livest/core/utils/exception/repository_exeption.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:livest/features/breader/marketplace/services/marketplace_service.dart';

class MarketplaceRepository {
  final MarketplaceService _service = MarketplaceService();

  Future<List<ProductModel>> getMyProduct(String userId) async {
    try {
      return await _service.getMyProduct(userId);
    } catch (e) {
      throw RepositoryException("Failed to fetch products");
    }
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      return await _service.createProduct(product);
    } catch (e) {
      throw RepositoryException("Failed to create product");
    }
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      return await _service.updateProduct(product);
    } catch (e) {
      throw RepositoryException("Failed to update product");
    }
  }

  Future<void> deleteProduct(int productId) async {
    try {
      await _service.deleteProduct(productId);
    } catch (e) {
      throw RepositoryException("Failed to delete product");
    }
  }

  Future<void> markAsSold(int productId) async {
    try {
      await _service.markProductAsSold(productId);
    } catch (e) {
      throw RepositoryException("Failed to mark product as sold");
    }
  }
}
