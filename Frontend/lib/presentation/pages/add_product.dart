import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controllers/product_controller.dart';

class AddProductPage extends StatefulWidget {
  final String coopEmail;
  const AddProductPage({required this.coopEmail, super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String nom = "", desc = "";
  double prix = 0;
  List<File> images = [];

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked != null) {
      setState(() => images = picked.map((x) => File(x.path)).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final productCtrl = Provider.of<ProductController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter produit")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Nom"),
                validator: (v) => v!.isEmpty ? "Nom requis" : null,
                onSaved: (v) => nom = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                onSaved: (v) => desc = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Prix"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Prix requis" : null,
                onSaved: (v) => prix = double.tryParse(v!) ?? 0,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(
                    child: Text("Choisir Images"),
                    onPressed: pickImages,
                  ),
                  SizedBox(width: 10),
                  if (images.isNotEmpty)
                    Text("${images.length} image(s) sélectionnée(s)")
                ],
              ),
              SizedBox(height: 18),
              ElevatedButton(
                child: Text("Ajouter"),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    await productCtrl.addProduct(
                      coopEmail: widget.coopEmail,
                      nom: nom,
                      description: desc,
                      prix: prix,
                      images: images,
                    );
                    Navigator.pop(context, true);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
