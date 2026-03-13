import 'package:evv/Componentes/General/Datos.dart';
import 'package:evv/Componentes/General/Principal.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // PALETA TURISGO
  final Color colorFondo = const Color(0xFF1A1A1A);
  final Color colorTarjeta = const Color(0xFF2D2D2D);
  final Color colorAcento = Colors.orangeAccent;
  final Color colorMarca = const Color(0xFF5F1E06);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'MENSAJES',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
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
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: colorTarjeta,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorAcento, width: 2),
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: colorMarca,
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
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  AppData.messages.isNotEmpty && i == 0
                      ? AppData.messages.last.text
                      : 'Hola, ¿todo listo para tu viaje?',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
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

  // PALETA TURISGO PARA EL CHAT
  final Color colorFondo = const Color(0xFF1A1A1A);
  final Color colorAcento = Colors.orangeAccent;
  final Color colorBurbujaOtro = const Color(0xFF2D2D2D);
  final Color colorMarca = const Color(0xFF5F1E06);

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _chat.add(
        Message(
          id: DateTime.now().toString(),
          fromUser: 'Yo',
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: colorMarca,
              backgroundImage: const NetworkImage(
                'https://picsum.photos/id/60/80',
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.contactName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      // Mi burbuja usa el color de marca, la otra el gris oscuro
                      color: m.isMe ? colorMarca : colorBurbujaOtro,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(22),
                        topRight: const Radius.circular(22),
                        bottomLeft: Radius.circular(m.isMe ? 22 : 0),
                        bottomRight: Radius.circular(m.isMe ? 0 : 22),
                      ),
                      border: m.isMe
                          ? Border.all(color: colorAcento.withOpacity(0.3))
                          : Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Text(
                      m.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // INPUT DE MENSAJE TURISGO
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 35),
            decoration: BoxDecoration(
              color: colorFondo,
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.05)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorBurbujaOtro,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Escribe a la agencia...',
                        hintStyle: TextStyle(
                          color: Colors.white24,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorAcento,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorAcento.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Color(0xFF5F1E06),
                      size: 22,
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
