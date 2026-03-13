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

  final Color colorFondo = const Color(0xFF1A1A1A);
  final Color colorAcento = Colors.orangeAccent;
  final Color colorMarca = const Color(0xFF5F1E06);

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
      backgroundColor: colorFondo,
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: colorAcento.withOpacity(0.2),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: const Color(0xFF252525),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined, color: Colors.white54),
              selectedIcon: Icon(Icons.home, color: colorAcento),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: const Icon(Icons.search_rounded, color: Colors.white54),
              selectedIcon: Icon(Icons.search_rounded, color: colorAcento),
              label: 'Buscar',
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.card_travel_outlined,
                color: Colors.white54,
              ),
              selectedIcon: Icon(Icons.card_travel, color: colorAcento),
              label: 'Viajes',
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white54,
              ),
              selectedIcon: Icon(Icons.chat_bubble_rounded, color: colorAcento),
              label: 'Chats',
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.person_outline_rounded,
                color: Colors.white54,
              ),
              selectedIcon: Icon(Icons.person, color: colorAcento),
              label: 'Perfil',
            ),
          ],
        ),
      ),
      floatingActionButton:
          AppData.currentUser['isProveedor'] == true ||
              AppData.currentUser['isAdmin'] == true
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddServiceScreen()),
              ),
              backgroundColor: colorAcento,
              elevation: 8,
              child: Icon(Icons.add, color: colorMarca, size: 30),
            )
          : null,
    );
  }
}
