import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart'; // adjust the import path as needed

class ProfilePage extends StatefulWidget {
  final String email, password, role;
  const ProfilePage({required this.email, required this.password, required this.role, Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _adresseController = TextEditingController();
  final _telephoneController = TextEditingController();

  bool _isLoading = false;

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final authController = Provider.of<AuthController>(context, listen: false);
      print('SENDING TO REGISTER:');
      print({
        "email": widget.email,
        "password": widget.password,
        "role": widget.role,
        "nom": _nomController.text,
        "adresse": _adresseController.text,
        "telephone": _telephoneController.text,
      });
      await authController.register(
        email: widget.email,
        password: widget.password,
        role: widget.role,
        nom: _nomController.text,
        adresse: _adresseController.text,
        telephone: _telephoneController.text,
        logoFile: null, // normal user: no logo
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inscription réussie')),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil utilisateur")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: "Nom"),
                validator: (v) => (v == null || v.isEmpty) ? "Nom requis" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _adresseController,
                decoration: InputDecoration(labelText: "Adresse"),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _telephoneController,
                decoration: InputDecoration(labelText: "Téléphone"),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _onRegister,
                child: _isLoading
                    ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text("Créer mon compte"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
