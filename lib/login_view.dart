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
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child:
                    _showPasswordStep
                        ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Contraseña',
                              style: TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
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
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _login,
                              child: const Text('Entrar'),
                            ),
                            TextButton(
                              onPressed:
                                  () =>
                                      setState(() => _showPasswordStep = false),
                              child: const Text('Volver'),
                            ),
                          ],
                        )
                        : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Bienvenido',
                              style: TextStyle(fontSize: 28),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: _inputDecoration(
                                'Correo electrónico',
                                Icons.email,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _nextStep,
                              child: const Text('Siguiente'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterView(),
                                  ),
                                );
                              },
                              child: const Text('Crear nueva cuenta'),
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
