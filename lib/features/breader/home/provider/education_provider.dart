import 'package:flutter/material.dart';
import 'package:livest/features/breader/home/models/education_model.dart';
import 'package:livest/features/breader/home/services/education_service.dart';

class EducationProvider extends ChangeNotifier {
  final EducationService _educationService = EducationService();

  List<EducationModel> _educations = [];
  bool _isLoading = false;

  List<EducationModel> get educations => _educations;
  bool get isLoading => _isLoading;

  Future<void> getEducation() async {
    _isLoading = true;
    notifyListeners();
    try {
      _educations = await _educationService.getEducation();
    } catch (e) {
      print("Error read: $e");
    }
    _isLoading = false;
    notifyListeners();
  }
}
