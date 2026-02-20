import 'package:evv/Componentes/General/Datos.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: ListView.builder(
        itemCount: AppData.notifications.length,
        itemBuilder: (context, i) {
          final n = AppData.notifications[i];
          return Dismissible(
            key: Key(n.id),
            onDismissed: (_) =>
                setState(() => AppData.notifications.removeAt(i)),
            child: ListTile(
              leading: Icon(
                n.read ? Icons.notifications : Icons.notifications_active,
                color: n.read ? Colors.grey : Colors.red,
              ),
              title: Text(n.title),
              subtitle: Text(n.body),
              trailing: Text('${n.time.hour}:${n.time.minute}'),
              onTap: () => setState(() => n.read = true),
            ),
          );
        },
      ),
    );
  }
}
