import 'package:flutter/material.dart';
import 'package:livest/data/models/education_model.dart';
import 'package:livest/features/breader/home/services/education_service.dart';

/// Provider untuk mengelola state konten edukasi.
/// Delegasi fetch ke EducationService (SRP).
class EducationProvider extends ChangeNotifier {
  final EducationService _educationService = EducationService();

  List<EducationModel> _educations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<EducationModel> get educations => List.unmodifiable(_educations);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch semua data edukasi via EducationService
  Future<void> fetchEducations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _educations = await _educationService.fetchAll();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
