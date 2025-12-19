import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constant.dart';
import '../controllers/product_controller.dart';
import 'add_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageProductsPage extends StatefulWidget {
  @override
  State<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  String? coopEmail;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      coopEmail = prefs.getString('user_email');
    });
    if (coopEmail != null) {
      Provider.of<ProductController>(context, listen: false).loadProducts(coopEmail!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productCtrl = Provider.of<ProductController>(context);

    if (coopEmail == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
          child: Row(
            children: [
              Text(
                'Mes produits',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => productCtrl.loadProducts(coopEmail!),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  final added = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => AddProductPage(coopEmail: coopEmail!)),
                  );
                  if (added == true) productCtrl.loadProducts(coopEmail!);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: productCtrl.isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: productCtrl.products.length,
            itemBuilder: (context, i) {
              final p = productCtrl.products[i];
              return Card(
                child: ListTile(
                  leading: (p['images'] != null && p['images'].isNotEmpty)
                      ? Image.network(AppConstants.baseUrl + p['images'][0], width: 60, fit: BoxFit.cover)
                      : Icon(Icons.image, size: 50),
                  title: Text(p['nom'] ?? ""),
                  subtitle: Text("${p['description'] ?? ''}\n${p['prix']} €"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await productCtrl.deleteProduct(coopEmail!, p['nom']);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
