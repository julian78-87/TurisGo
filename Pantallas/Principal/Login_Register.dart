import 'package:evv/Componentes/General/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  bool isLoading = false;

  final Color colorFondo = const Color(0xFF1A1A1A);
  final Color colorPrimario = Colors.orangeAccent;
  final Color colorAppBar = const Color(0xFF5F1E06);
  final Color colorTextoClaro = Colors.white;
  final Color colorTextoOscuro = const Color(0xFF2D2D2D);

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();

  final supabase = Supabase.instance.client;

  Future<void> _authenticate() async {
    final email = _emailController.text.trim();
    final password = _passController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || (!isLogin && name.isEmpty)) {
      _showMsg("Por favor, llene todos los campos");
      return;
    }

    setState(() => isLoading = true);

    try {
      if (isLogin) {
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } else {
        final AuthResponse res = await supabase.auth.signUp(
          email: email,
          password: password,
          data: {'full_name': name},
        );
        final user = res.user;
        if (user != null) {
          try {
            await supabase.from('profiles').insert({
              'id': user.id,
              'full_name': name,
              'role': 'prestador',
            });
          } catch (e) {
            debugPrint("Error insertando perfil: $e");
          }
        }
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } on AuthException catch (e) {
      _showMsg(e.message);
    } catch (e) {
      _showMsg("Ocurrió un error inesperado");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: colorAppBar,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showRecoverPasswordDialog() {
    final recoverController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Recuperar contraseña',
          style: TextStyle(color: colorPrimario),
        ),
        content: TextField(
          controller: recoverController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            labelStyle: const TextStyle(color: Colors.white70),
            hintText: 'ejemplo@correo.com',
            hintStyle: const TextStyle(color: Colors.white30),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colorPrimario),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = recoverController.text.trim();
              if (email.isEmpty) return;
              try {
                await supabase.auth.resetPasswordForEmail(email);
                if (mounted) {
                  Navigator.pop(context);
                  _showMsg("Se ha enviado un correo de recuperación");
                }
              } catch (e) {
                _showMsg("Error al enviar el correo");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrimario,
              foregroundColor: Colors.black,
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorAppBar, colorFondo],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 10,
              color: Colors.white.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.white10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.travel_explore, size: 70, color: colorPrimario),
                    const SizedBox(height: 20),
                    Text(
                      isLogin ? 'BIENVENIDO A TURIS-GO' : 'CREA TU CUENTA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: colorTextoClaro,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (!isLogin) ...[
                      _buildTextField(
                        controller: _nameController,
                        label: 'Nombre completo',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildTextField(
                      controller: _emailController,
                      label: 'Correo electrónico',
                      icon: Icons.email_outlined,
                      keyboard: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passController,
                      label: 'Contraseña',
                      icon: Icons.lock_outline,
                      isPass: true,
                    ),
                    if (isLogin)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _showRecoverPasswordDialog,
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              color: colorPrimario,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),
                    isLoading
                        ? CircularProgressIndicator(color: colorPrimario)
                        : ElevatedButton(
                            onPressed: _authenticate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimario,
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              isLogin ? 'INGRESAR' : 'REGISTRARSE',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                          _emailController.clear();
                          _passController.clear();
                          _nameController.clear();
                        });
                      },
                      child: Text(
                        isLogin
                            ? '¿No tienes cuenta? Regístrate'
                            : '¿Ya tienes cuenta? Inicia sesión',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPass = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      keyboardType: keyboard,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: colorPrimario),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colorPrimario),
        ),
      ),
    );
  }
}
