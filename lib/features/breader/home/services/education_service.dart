import 'package:livest/core/services/base_supabase_service.dart';
import 'package:livest/data/models/education_model.dart';

class EducationService extends BaseSupabaseService<EducationModel> {
  @override
  String get tableName => 'educations';

  getEducation() async {
    final response = await _supabaseClient.from('educations').select();

    return (response as List).map((e) => EducationModel.fromJson(e)).toList();
  }
}
