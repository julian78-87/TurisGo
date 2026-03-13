import 'package:evv/Pantallas/Principal/initial.dart';
import 'package:flutter/material.dart';

class ExploraTurismoApp extends StatelessWidget {
  const ExploraTurismoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TurisGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const intial(),
    );
  }
}

class TouristService {
  final String id;
  final String nombre;
  final String ubicacion;
  final String descripcion;
  final double precio;
  final String imagen;
  final String categoria;
  double rating;
  int reviews;
  final String proveedor;

  TouristService({
    required this.id,
    required this.nombre,
    required this.ubicacion,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.categoria,
    this.rating = 4.5,
    this.reviews = 124,
    required this.proveedor,
  });
}

class Reservation {
  final String id;
  final TouristService service;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int personas;
  final double total;
  final String estado;

  Reservation({
    required this.id,
    required this.service,
    required this.fechaInicio,
    required this.fechaFin,
    required this.personas,
    required this.total,
    required this.estado,
  });
}

class Message {
  final String id;
  final String fromUser;
  final String text;
  final DateTime time;
  final bool isMe;

  Message({
    required this.id,
    required this.fromUser,
    required this.text,
    required this.time,
    required this.isMe,
  });
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  bool read;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.read = false,
  });
}
