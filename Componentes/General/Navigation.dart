import 'package:evv/Pantallas/Sub/AddService.dart';
import 'package:evv/Componentes/General/Datos.dart';
import 'package:evv/Pantallas/Principal/Home.dart';
import 'package:evv/Pantallas/Principal/Menssaje.dart';
import 'package:evv/Pantallas/Principal/MyReserv.dart';
import 'package:evv/Pantallas/Principal/Profil.dart';
import 'package:evv/Pantallas/Principal/Search_Filter.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final colorCoral = const Color(0xFFFF6B6B);

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const MyReservationsPage(),
    const MessagesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        indicatorColor: colorCoral.withOpacity(0.5),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
          NavigationDestination(
            icon: Icon(Icons.card_travel),
            label: 'Reservas',
          ),
          NavigationDestination(icon: Icon(Icons.chat), label: 'Mensajes'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
      floatingActionButton:
          AppData.currentUser['isProveedor'] == true ||
              AppData.currentUser['isAdmin'] == true
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddServiceScreen()),
              ),
              backgroundColor: colorCoral.withOpacity(0.7),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
