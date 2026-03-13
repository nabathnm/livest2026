import 'package:flutter/material.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:livest/features/buyer/home/services/search_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchProvider extends ChangeNotifier {
  final SearchService _service = SearchService();
  String _query = '';
  List<ProductModel> _results = [];
  List<String> _history = [];
  bool _isLoading = false;
  bool _hasSearched = false; 
  String get query => _query;
  List<ProductModel> get results => _results;
  List<String> get history => _history;
  bool get isLoading => _isLoading;
  bool get hasSearched => _hasSearched;
  bool get isEmpty => _hasSearched && !_isLoading && _results.isEmpty;

  static const _historyKey = 'search_history';
  static const _maxHistory = 10;
  SearchProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList(_historyKey) ?? [];
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, _history);
  }
  Future<void> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;

    _query = q;
    _isLoading = true;
    _hasSearched = true;
    notifyListeners();
    _history.remove(q);
    _history.insert(0, q);
    if (_history.length > _maxHistory)
      _history = _history.sublist(0, _maxHistory);
    await _saveHistory();

    try {
      _results = await _service.searchProducts(q);
    } catch (e) {
      debugPrint('Search error: $e');
      _results = [];
    }

    _isLoading = false;
    notifyListeners();
  }
  Future<void> searchFromHistory(String query) => search(query);
  void reset() {
    _query = '';
    _results = [];
    _hasSearched = false;
    _isLoading = false;
    notifyListeners();
  }
  Future<void> removeHistory(String item) async {
    _history.remove(item);
    await _saveHistory();
    notifyListeners();
  }
  Future<void> clearHistory() async {
    _history.clear();
    await _saveHistory();
    notifyListeners();
  }
}
