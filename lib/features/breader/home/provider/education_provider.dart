import 'package:flutter/material.dart';
import 'package:livest/core/data/models/education_model.dart';
import 'package:livest/features/breader/home/services/education_service.dart';

class EducationProvider extends ChangeNotifier {
  final EducationService _educationService = EducationService();

  List<EducationModel> _educations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<EducationModel> get educations => _educations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchEducations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _educations = await _educationService.fetchAll();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Error read: $e");
    }
    _isLoading = false;
    notifyListeners();
  }
}
