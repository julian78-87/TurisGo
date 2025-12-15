import 'package:evv/Main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pahzuxcorvdnquuprgme.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBhaHp1eGNvcnZkbnF1dXByZ21lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NzMwODEsImV4cCI6MjA3NzE0OTA4MX0.HVbgykbXZgCaay_y18X6wRVoT7TWETLJOywtTruf0jY',
  );

  runApp(Conexion());
}
