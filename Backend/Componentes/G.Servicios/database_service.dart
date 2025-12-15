import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class DatabaseService {
  static Future<void> deleteService(int id) {
    return supabase.from('services').delete().eq('id', id);
  }

  static Future<void> updateService(int id, Map<String, dynamic> data) {
    return supabase.from('services').update(data).eq('id', id);
  }
}
