import 'package:livest/features/breader/home/models/education_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EducationService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final table = "educations";

  // Fetch
  Future<List<EducationModel>> fetchData() async {
    final data = await _supabaseClient.from(table).select();
    return data.map((e) => EducationModel.fromJson(e)).toList();
  }
}
