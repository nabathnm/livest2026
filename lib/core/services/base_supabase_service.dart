import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BaseSupabaseService<T> {
  final SupabaseClient _client = Supabase.instance.client;

  String get tableName;

  SupabaseClient get client => _client;

  T fromJson(Map<String, dynamic> json);

  Future<List<T>> fetchAll() async {
    final data = await _client.from(tableName).select();
    return data.map((e) => fromJson(e)).toList();
  }

  Future<T?> fetchById(dynamic id) async {
    final data = await _client
        .from(tableName)
        .select()
        .eq('id', id)
        .maybeSingle();
    return data != null ? fromJson(data) : null;
  }

  Future<void> upsert(Map<String, dynamic> data) async {
    await _client.from(tableName).upsert(data);
  }

  Future<void> deleteById(dynamic id) async {
    await _client.from(tableName).delete().eq('id', id);
  }
}
