// lib/features/breader/home/provider/education_provider.dart

import 'package:flutter/material.dart';
import 'package:livest/features/breader/home/models/education_data.dart';
import 'package:livest/features/breader/home/models/education_model.dart';

class EducationProvider extends ChangeNotifier {
  String? _selectedCategory; // null = semua kategori
  String _searchQuery = '';

  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  static const List<String> categories = ['Kesehatan', 'Perawatan', 'Pakan'];

  List<EducationModel> get filteredArtikel {
    return dummyArtikel.where((a) {
      // Filter kategori (null = tampilkan semua)
      final matchCat =
          _selectedCategory == null || a.category == _selectedCategory;

      // Filter search (kosong = tampilkan semua)
      final q = _searchQuery.toLowerCase().trim();
      final matchSearch =
          q.isEmpty ||
          a.title.toLowerCase().contains(q) ||
          a.shortDesc.toLowerCase().contains(q) ||
          a.category.toLowerCase().contains(q);

      return matchCat && matchSearch;
    }).toList();
  }

  /// Toggle kategori: tap kategori yang sama → deselect (kembali ke semua)
  void setCategory(String cat) {
    if (_selectedCategory == cat) {
      _selectedCategory = null; // deselect → tampilkan semua
    } else {
      _selectedCategory = cat;
    }
    notifyListeners();
  }

  /// Dipanggil dari search bar
  void setSearch(String q) {
    _searchQuery = q;
    // Saat user mengetik, kategori direset agar search bersifat general
    if (q.isNotEmpty) {
      _selectedCategory = null;
    }
    notifyListeners();
  }

  /// Dipanggil saat chip kategori di-tap dari luar (misal dari home)
  void setCategoryAndClearSearch(String cat) {
    _selectedCategory = cat;
    _searchQuery = '';
    notifyListeners();
  }

  void reset() {
    _selectedCategory = null;
    _searchQuery = '';
    notifyListeners();
  }
}
