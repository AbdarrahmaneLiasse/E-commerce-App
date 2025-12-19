import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'profilePage.dart';
import 'cooperativeProfilePage.dart'; // Import this

class RegistrationPage extends StatefulWidget {
  final String email;
  RegistrationPage({required this.email});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  String _selectedRole = 'NORMAL_USER';

  void _goToProfile() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == 'NORMAL_USER') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfilePage(
              email: widget.email,
              password: _passwordController.text,
              role: _selectedRole,
            ),
          ),
        );
      } else if (_selectedRole == 'COOPERATION') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CooperativeProfilePage(
              email: widget.email,
              password: _passwordController.text,
              role: _selectedRole,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un compte")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Étape 1: Créez vos identifiants"),
              SizedBox(height: 16),
              TextFormField(
                enabled: false,
                initialValue: widget.email,
                decoration: InputDecoration(
                  labelText: "E-mail",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value != null && value.length >= 6 ? null : "6 caractères minimum",
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: [
                  DropdownMenuItem(value: 'NORMAL_USER', child: Text("Utilisateur normal")),
                  DropdownMenuItem(value: 'COOPERATION', child: Text("Coopérative")),
                ],
                onChanged: (val) => setState(() => _selectedRole = val!),
                decoration: InputDecoration(labelText: "Rôle"),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _goToProfile,
                child: Text("Continuer"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
