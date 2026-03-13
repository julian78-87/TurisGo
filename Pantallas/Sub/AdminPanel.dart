import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  int _selectedIndex = 0;
  final colorFondo = const Color(0xFF131313);
  final colorTarjeta = const Color(0xFF1E1E1E);
  final colorAcento = const Color(0xFFFF9800);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: colorTarjeta,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) =>
                setState(() => _selectedIndex = index),
            labelType: NavigationRailLabelType.all,
            selectedIconTheme: IconThemeData(color: colorAcento),
            unselectedIconTheme: const IconThemeData(color: Colors.white54),
            selectedLabelTextStyle: TextStyle(
              color: colorAcento,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white54),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Métricas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.luggage),
                label: Text('Servicios'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Usuarios'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.history),
                label: Text('Reservas'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Colors.white10),
          Expanded(child: _buildCurrentTab()),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_selectedIndex) {
      case 0:
        return _buildMetricsTab();
      case 1:
        return _buildManagementList('services', 'nombre');
      case 2:
        return _buildManagementList('profiles', 'username');
      case 3:
        return _buildManagementList('reservations', 'status');
      default:
        return const Center(
          child: Text('En desarrollo', style: TextStyle(color: Colors.white)),
        );
    }
  }

  Widget _buildMetricsTab() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "DASHBOARD ADMINISTRATIVO",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              _metricCard("Total Servicios", "24", Icons.hotel, Colors.blue),
              _metricCard(
                "Reservas Hoy",
                "12",
                Icons.calendar_today,
                Colors.green,
              ),
              _metricCard(
                "Pendientes",
                "5",
                Icons.warning_amber,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorTarjeta,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementList(String table, String displayColumn) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Supabase.instance.client.from(table).stream(primaryKey: ['id']),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final data = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: data.length,
          itemBuilder: (context, i) {
            final item = data[i];
            return Card(
              color: colorTarjeta,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                title: Text(
                  item[displayColumn]?.toString() ?? "Sin nombre",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "ID: ${item['id']}",
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  onPressed: () => _deleteItem(table, item['id']),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteItem(String table, dynamic id) async {
    await Supabase.instance.client.from(table).delete().eq('id', id);
  }
}
