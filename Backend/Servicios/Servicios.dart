import 'dart:math';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final Map<String, Map<String, String>> _users = {};
  final Map<String, String> _tokens = {};

  bool emailOk(String e) => RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(e);

  String register(String nombre, String correo, String pass) {
    correo = correo.toLowerCase();
    if (nombre.isEmpty || correo.isEmpty) return "Campos vacíos";
    if (!emailOk(correo)) return "Correo inválido";
    if (pass.length < 6) return "Contraseña débil";
    if (_users.containsKey(correo)) return "Correo ya existe";

    _users[correo] = {'nombre': nombre, 'pass': pass};
    return "OK";
  }

  String login(String correo, String pass) {
    correo = correo.toLowerCase();
    final u = _users[correo];
    if (u == null) return "No existe";
    if (u['pass'] != pass) return "Incorrecto";
    return "OK";
  }

  String reset(String correo) {
    correo = correo.toLowerCase();
    if (!_users.containsKey(correo)) return "No registrado";
    final token = Random().nextInt(999999).toString().padLeft(6, "0");
    _tokens[correo] = token;
    return "Token enviado: $token";
  }

  Map<String, Map<String, String>> get all => _users;
}
