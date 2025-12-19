import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'authPage.dart';
import 'registrationPage.dart';

class EmailSelectorUI extends StatefulWidget {
  @override
  State<EmailSelectorUI> createState() => _EmailSelectorUIState();
}

class _EmailSelectorUIState extends State<EmailSelectorUI> {
  final _emailController = TextEditingController();
  final _controller = AuthController();
  bool _isLoading = false;

  Future<void> _checkEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final exists = await _controller.checkEmail(email);
      setState(() => _isLoading = false);

      if (exists) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AuthPage(email: email)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RegistrationPage(email: email)),
        );
      }
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
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.email_outlined, size: 48, color: Colors.indigo),
                  SizedBox(height: 16),
                  Text(
                    "Bienvenue.\nSélectionner votre E-mail",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Adresse e-mail",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _checkEmail,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text("Vérifier"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
