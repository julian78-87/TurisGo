import 'package:evv/Pantallas/Principal.dart';

class AppData {
  static List<TouristService> services = [
    TouristService(
      id: '1',
      nombre: 'Hotel Playa Paraíso',
      ubicacion: 'San Andrés, Colombia',
      descripcion: 'Frente al mar con todo incluido',
      precio: 285000,
      imagen: 'https://picsum.photos/id/1015/600/400',
      categoria: 'Casa',
      proveedor: 'Hotel SAS',
    ),
    TouristService(
      id: '2',
      nombre: 'Trekking Nevado del Ruiz',
      ubicacion: 'Manizales',
      descripcion: 'Aventura de 2 días con guías',
      precio: 185000,
      imagen: 'https://picsum.photos/id/133/600/400',
      categoria: 'Hostal',
      proveedor: 'EcoAventura',
    ),
    TouristService(
      id: '3',
      nombre: 'Tour Ciudad Perdida',
      ubicacion: 'Santa Marta',
      descripcion: '4 días en la selva',
      precio: 890000,
      imagen: 'https://picsum.photos/id/201/600/400',
      categoria: 'Cultura',
      proveedor: 'TrekColombia',
    ),
    TouristService(
      id: '4',
      nombre: 'Glamping Montaña Mágica',
      ubicacion: 'Salento',
      descripcion: 'Cabañas con jacuzzi',
      precio: 320000,
      imagen: 'https://picsum.photos/id/251/600/400',
      categoria: 'Casa',
      proveedor: 'GlampCol',
    ),
    TouristService(
      id: '5',
      nombre: 'Paseo en Barco Cartagena',
      ubicacion: 'Cartagena',
      descripcion: 'Atardecer con cena',
      precio: 95000,
      imagen: 'https://picsum.photos/id/870/600/400',
      categoria: 'Hotel',
      proveedor: 'MarTour',
    ),
  ];

  static List<Reservation> myReservations = [];
  static List<Message> messages = [];
  static List<NotificationItem> notifications = [];
  static Map<String, dynamic> currentUser = {
    'nombre': 'Cristian Andrés',
    'email': 'cristian@example.com',
    'foto': 'https://static.dw.com/image/44777236_804.jpg',
    'isAdmin': true,
    'isProveedor': false,
    'ratingPromedio': 4.8,
  };

  static void addDummyData() {
    notifications = [
      NotificationItem(
        id: 'n1',
        title: 'Reserva confirmada',
        body: 'Tu reserva en Hotel Playa Paraíso está confirmada',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        read: false,
      ),
      NotificationItem(
        id: 'n2',
        title: 'Nuevo mensaje',
        body: 'EcoAventura te escribió',
        time: DateTime.now().subtract(const Duration(hours: 5)),
        read: true,
      ),
    ];

    messages = [
      Message(
        id: 'm1',
        fromUser: 'EcoAventura',
        text: 'Hola Cristian, ¿confirmamos la fecha del trekking?',
        time: DateTime.now().subtract(const Duration(hours: 3)),
        isMe: false,
      ),
      Message(
        id: 'm2',
        fromUser: 'Cristian Andrés',
        text: 'Sí, perfecto el 25 de febrero',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: true,
      ),
    ];
  }
}
