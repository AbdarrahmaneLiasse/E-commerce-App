import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
// Import your home screens below
import 'homeShellUn.dart';

class AuthPage extends StatefulWidget {
  final String email;
  AuthPage({required this.email});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyPassword() async {
    final password = _passwordController.text.trim();
    if (password.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final authController = Provider.of<AuthController>(context, listen: false);
      final data = await authController.login(
        context: context,
        email: widget.email,
        password: password,
      );

      setState(() => _isLoading = false);

      // Role-based navigation
      final role = (data['role'] as String).toUpperCase();
      Navigator.pushReplacementNamed(
        context,
        "/HomeShell",
        arguments: role,
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showError("Erreur: $e");
    }

  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Authentification")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Bienvenue ${widget.email}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Mot de passe",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyPassword,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Se connecter"),
            )
          ],
        ),
      ),
    );
  }
}
