import 'package:livest/features/admin/dashboard/models/database_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;
  final table = "educations";

  // Fetch
  Future<List<DatabaseModel>> fetchData() async {
    final data = await supabase.from(table).select();
    return data.map((e) => DatabaseModel.fromMap(e)).toList();
  }

  // Insert
  Future<void> insertRow(DatabaseModel newDatabaseModel) async {
    await supabase.from(table).insert(newDatabaseModel.toMap());
  }

  // Update
  Future<void> updateRow(DatabaseModel updateDatabaseModel) async {
    await supabase
        .from(table)
        .update(updateDatabaseModel.toMap())
        .eq('id', updateDatabaseModel.id!);
  }

  // Delete
  Future<void> deleteRow({required int id}) async {
    await supabase.from(table).delete().eq('id', id);
  }
}
