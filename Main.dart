import 'package:evv/Pantallas/Principal.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://boxmnuhfjbkdcppkhmyk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJveG1udWhmamJrZGNwcGtobXlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3MTM5OTgsImV4cCI6MjA3OTI4OTk5OH0.1ePe_goj4BCDj463AjbVrFBFk2DpKShZC4v9HvDDQB8',
  );

  runApp(ExploraTurismoApp());
}

final supabase = Supabase.instance.client;
