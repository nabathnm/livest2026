import 'package:livest/core/services/base_supabase_service.dart';
import 'package:livest/data/models/education_category_model.dart';

/// Service untuk fetch kategori edukasi dari Supabase.
/// Extends BaseSupabaseService — hanya perlu definisikan tableName & fromJson.
class EducationCategoryService extends BaseSupabaseService<EducationCategoryModel> {
  @override
  String get tableName => 'education_categories';

  @override
  EducationCategoryModel fromJson(Map<String, dynamic> json) {
    return EducationCategoryModel.fromJson(json);
  }
}
