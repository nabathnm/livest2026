import 'package:livest/features/breader/home/models/education_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EducationService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final table = "educations";

  getEducation() async {
    final response = await _supabaseClient.from('educations').select();

    return (response as List).map((e) => EducationModel.fromJson(e)).toList();
  }
}
