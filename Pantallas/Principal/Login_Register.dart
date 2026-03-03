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

  // --- PALETA TURISGO (No tocar lógica) ---
  final Color colorAbismo = const Color(0xFF0F172A);
  final Color colorCerceta = const Color(0xFF0D9488);
  final Color colorCoral = const Color(0xFFFF6B6B);
  final Color colorTexto = const Color(0xFF1E293B);

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
        backgroundColor: colorCoral, // Ajuste a color de la paleta
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showRecoverPasswordDialog() {
    final recoverController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Recuperar contraseña'),
        content: TextField(
          controller: recoverController,
          decoration: InputDecoration(
            labelText: 'Ingresa tu correo electrónico',
            hintText: 'ejemplo@correo.com',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: colorTexto.withOpacity(0.5)),
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
            style: ElevatedButton.styleFrom(backgroundColor: colorCerceta),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorAbismo, colorCerceta],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 0,
              color: Colors.white.withOpacity(0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.explore_rounded, // Cambio a un icono más "viajero"
                      size: 80,
                      color: colorCerceta,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isLogin ? 'BIENVENIDO A TurisGo' : 'CREA TU CUENTA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: colorTexto,
                        letterSpacing: 1.2,
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
                    const SizedBox(height: 8),
                    if (isLogin)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _showRecoverPasswordDialog,
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              color: colorCerceta,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),
                    isLoading
                        ? CircularProgressIndicator(color: colorCerceta)
                        : ElevatedButton(
                            onPressed: _authenticate,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: colorCoral,
                              foregroundColor: Colors.white,
                              elevation: 4,
                            ),
                            child: Text(
                              isLogin ? 'INGRESAR' : 'REGISTRARSE',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
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
                        style: TextStyle(color: colorTexto.withOpacity(0.6)),
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
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: colorCerceta),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
