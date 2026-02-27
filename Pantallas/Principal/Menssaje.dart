import 'package:evv/Componentes/General/Datos.dart';
import 'package:evv/Componentes/General/Principal.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final colorFondo = const Color(0xFF0F172A);
  final colorTarjeta = const Color(0xFF1E293B);
  final colorAcento = const Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorFondo,
        title: const Text(
          'MENSAJES',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 4,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (context, i) {
          final nombres = [
            'EcoAventura',
            'Hotel Paraíso',
            'TrekColombia',
            'GlampCol',
          ];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: colorTarjeta.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              leading: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorAcento, width: 2),
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    'https://picsum.photos/id/${50 + i}/80',
                  ),
                ),
              ),
              title: Text(
                nombres[i],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                AppData.messages.isNotEmpty && i == 0
                    ? AppData.messages.last.text
                    : 'Hola, ¿todo listo para tu viaje?',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
              trailing: const Text(
                '14:32',
                style: TextStyle(color: Colors.white24, fontSize: 11),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(contactName: nombres[i]),
                ),
              ),
            ),
          );
        },
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

  final colorFondo = const Color(0xFF0F172A);
  final colorAcento = const Color(0xFF10B981);
  final colorBurbujaOtro = const Color(0xFF1E293B);

  void _send() {
    if (_controller.text.trim().isEmpty) return;
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
      backgroundColor: colorFondo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorFondo,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://picsum.photos/id/60/80'),
            ),
            const SizedBox(width: 12),
            Text(widget.contactName, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _chat.length,
              itemBuilder: (context, i) {
                final m = _chat[i];
                return Align(
                  alignment: m.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: m.isMe ? colorAcento : colorBurbujaOtro,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(m.isMe ? 20 : 0),
                        bottomRight: Radius.circular(m.isMe ? 0 : 20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      m.text,
                      style: TextStyle(
                        color: m.isMe ? colorFondo : Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // INPUT DE MENSAJE ESTILIZADO
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
            decoration: BoxDecoration(
              color: colorFondo,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorBurbujaOtro,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Escribe algo...',
                        hintStyle: TextStyle(color: Colors.white24),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _send,
                  child: CircleAvatar(
                    backgroundColor: colorAcento,
                    child: Icon(
                      Icons.send_rounded,
                      color: colorFondo,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
