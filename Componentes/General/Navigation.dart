import 'package:evv/Pantallas/AddService.dart';
import 'package:evv/Componentes/General/Datos.dart';
import 'package:evv/Pantallas/Home.dart';
import 'package:evv/Pantallas/Menssaje.dart';
import 'package:evv/Pantallas/MyReserv.dart';
import 'package:evv/Pantallas/Profil.dart';
import 'package:evv/Pantallas/Search_Filter.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

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
              child: const Icon(Icons.add),
              backgroundColor: Colors.teal,
            )
          : null,
    );
  }
}
