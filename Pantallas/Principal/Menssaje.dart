import 'package:evv/Componentes/General/Datos.dart';
import 'package:evv/Pantallas/Principal.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mensajes')),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, i) => ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://picsum.photos/id/${50 + i}/80',
            ),
          ),
          title: Text(
            ['EcoAventura', 'Hotel Paraíso', 'TrekColombia', 'GlampCol'][i],
          ),
          subtitle: Text(
            AppData.messages.isNotEmpty && i == 0
                ? AppData.messages.last.text
                : 'Hola, ¿todo listo para tu viaje?',
          ),
          trailing: const Text('14:32'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                contactName: [
                  'EcoAventura',
                  'Hotel Paraíso',
                  'TrekColombia',
                  'GlampCol',
                ][i],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String contactName;
  const ChatScreen({super.key, required this.contactName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final List<Message> _chat = List.from(AppData.messages);

  void _send() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _chat.add(
        Message(
          id: DateTime.now().toString(),
          fromUser: 'Cristian Andrés',
          text: _controller.text,
          time: DateTime.now(),
          isMe: true,
        ),
      );
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.contactName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _chat.length,
              itemBuilder: (context, i) {
                final m = _chat[i];
                return Align(
                  alignment: m.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: m.isMe ? Colors.teal : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      m.text,
                      style: TextStyle(
                        color: m.isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
