import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class StorageService {
  static Future<String?> uploadServiceImage(File file) async {
    final name = 'services/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage
        .from('services')
        .upload(name, file, fileOptions: const FileOptions(upsert: true));

    return supabase.storage.from('services').getPublicUrl(name);
  }
}
