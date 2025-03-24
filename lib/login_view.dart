import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'main.dart';
import 'auth_service.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPasswordStep = false;

  void _nextStep() {
    if (EmailValidator.validate(_emailController.text)) {
      setState(() => _showPasswordStep = true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Correo inválido')));
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService.login(
          _emailController.text,
          _passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MyHomePage(title: 'ToDo List'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de gradiente
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Capa de blur para efecto glassmorphism
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child:
                            !_showPasswordStep
                                ? Column(
                                  key: const ValueKey(1),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Bienvenido',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    TextFormField(
                                      controller: _emailController,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: _inputDecoration(
                                        'Correo electrónico',
                                        Icons.email,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: _nextStep,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.3),
                                      ),
                                      child: const Text('Siguiente'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => const RegisterView(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        '¿No tienes cuenta? Regístrate',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                  ],
                                )
                                : Column(
                                  key: const ValueKey(2),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Contraseña',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: _inputDecoration(
                                        'Contraseña',
                                        Icons.lock,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.length < 8) {
                                          return 'Mínimo 8 caracteres';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.3),
                                      ),
                                      child: const Text('Entrar'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => setState(
                                            () => _showPasswordStep = false,
                                          ),
                                      child: const Text(
                                        'Volver',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }
}
