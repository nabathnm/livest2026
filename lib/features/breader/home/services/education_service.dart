import 'package:livest/core/services/base_supabase_service.dart';
import 'package:livest/data/models/education_model.dart';

class EducationService extends BaseSupabaseService<EducationModel> {
  @override
  String get tableName => 'educations';

  @override
  EducationModel fromJson(Map<String, dynamic> json) {
    return EducationModel.fromJson(json);
  }
}
