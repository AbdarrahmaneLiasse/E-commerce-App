import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart'; // adjust path as needed

class CooperativeProfilePage extends StatefulWidget {
  final String email, password, role;
  const CooperativeProfilePage({required this.email, required this.password, required this.role, Key? key}) : super(key: key);

  @override
  State<CooperativeProfilePage> createState() => _CooperativeProfilePageState();
}

class _CooperativeProfilePageState extends State<CooperativeProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _adresseController = TextEditingController();
  final _telephoneController = TextEditingController();

  File? _logoFile;
  bool _isLoading = false;

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _logoFile = File(picked.path));
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_logoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Veuillez importer le logo de la coopérative")));
      return;
    }
    setState(() => _isLoading = true);

    try {
      final authController = Provider.of<AuthController>(context, listen: false);
      await authController.register(
        email: widget.email,
        password: widget.password,
        role: widget.role,
        nom: _nomController.text,
        adresse: _adresseController.text,
        telephone: _telephoneController.text,
        logoFile: _logoFile, // cooperative: send logo file
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
      appBar: AppBar(title: Text("Profil Coopérative")),
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
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickLogo,
                    child: Text(_logoFile == null ? "Importer logo" : "Changer le logo"),
                  ),
                  SizedBox(width: 16),
                  _logoFile == null
                      ? Container()
                      : Image.file(_logoFile!, height: 48),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _onRegister,
                child: _isLoading
                    ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text("Créer mon compte"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
