import 'package:evv/Pantallas/Principal/Login_Register.dart';
import 'package:flutter/material.dart';

class intial extends StatelessWidget {
  const intial({super.key});

  @override
  Widget build(BuildContext context) {
    const String background =
        "https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=1920";
    const String logoUrl =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_xV9zX4Q7L1p2y3w5v6u7i8o9p0a1s2d3f4g5h6j7k8l9z0x1c2v3b4n";
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InfoAppPage()),
            );
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipOval(
                      child: Image.network(
                        logoUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.travel_explore,
                            color: Colors.orange,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "TURIS-GO",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text("Inicio Sesion"),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(background),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 140),
                const Text(
                  "TOLIMA",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 6,
                  ),
                ),
                const Text(
                  "Tierra de Horizontes Y Bellezas Naturales",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "CAPITAL MUSICAL DE COLOMBIA",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _culturalIcon(Icons.music_note, "Bambuco"),
                    _culturalIcon(Icons.restaurant_menu, "Lechona"),
                    _culturalIcon(Icons.terrain, "Nevados"),
                    _culturalIcon(Icons.festival, "San Juan"),
                  ],
                ),
                const SizedBox(height: 50),
                _infoSection(
                  "Sobre Ibagué y Tolima",
                  "Contrastes Climáticos: Puedes pasar del calor de los ríos y represas al frío extremo.\n\n"
                      "Riqueza Cultural: Ibagué es un hervidero de música, arte y gastronomía única.\n\n"
                      "Diversidad Natural: Desde los páramos hasta las llanuras del Magdalena.",
                ),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _quickCard(
                        "Clima",
                        "Promedio 21°C - 28°C",
                        Icons.wb_sunny,
                      ),
                      _quickCard("Altitud", "1.285 m s. n. m.", Icons.height),
                      _quickCard("Gentilicio", "Tolimenses", Icons.people),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Lugares Imperdibles",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                _placeItem(
                  "Cañón del Combeima",
                  "Puerta de entrada al Parque de los Nevados.",
                ),
                _placeItem("Teatro Tolima", "Icono arquitectónico y cultural."),
                _placeItem(
                  "Plaza de Bolívar",
                  "Corazón histórico rodeado de Samanes.",
                ),
                _placeItem(
                  "Panóptico de Ibagué",
                  "Centro de artes y memoria regional.",
                ),
                const SizedBox(height: 40),
                _infoSection(
                  "Sabor Tolimense",
                  "Técnica y Paciencia: Cocción lenta en hornos de barro y leña con aromas de hoja de bijao.\n\n"
                      "Protagonistas: La auténtica lechona (sin arroz) y el tamal tolimense.",
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _infoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _quickCard(String title, String desc, IconData icon) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 30),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  static Widget _placeItem(String title, String subtitle) {
    return ListTile(
      leading: const Icon(Icons.location_on, color: Colors.orangeAccent),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white60, fontSize: 13),
      ),
    );
  }

  static Widget _culturalIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF5F1E06),
          child: Icon(icon, color: Colors.orangeAccent, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class InfoAppPage extends StatelessWidget {
  const InfoAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text("Sobre TURIS-GO"),
        backgroundColor: const Color(0xFF5F1E06),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.travel_explore,
                  size: 80,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Nuestra Misión",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "TURIS-GO es una plataforma diseñada para conectar a los viajeros con la esencia del Tolima. "
                "Buscamos promover el turismo sostenible, resaltando la gastronomía auténtica y los destinos "
                "que hacen vibrar a nuestra región.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              _infoFeature(Icons.music_note, "Impulso a la cultura musical."),
              _infoFeature(Icons.landscape, "Rutas de naturaleza y nevados."),
              _infoFeature(Icons.restaurant, "Guía gastronómica tradicional."),

              const SizedBox(height: 50),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Volver al Inicio"),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _infoFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 24),
          const SizedBox(width: 15),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ],
      ),
    );
  }
}
