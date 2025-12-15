import 'package:evv/Pantallas/Gestion_servicios_turisticos.dart';
import 'package:flutter/material.dart';


 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ingreso de Servicios Turísticos',
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
