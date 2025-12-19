import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/product_details.dart';
import 'package:provider/provider.dart';
import '../../shared_preferences/shared_preferences_helper.dart';
import '../controllers/favori_controller.dart';

class FavoriPage extends StatefulWidget {
  const FavoriPage({Key? key}) : super(key: key);

  @override
  State<FavoriPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoriPage> {
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserAndFavorites();
  }

  Future<void> _loadUserAndFavorites() async {
    final uid = await SharedPreferencesHelper.getUserId();
    setState(() => userId = uid);
    if (uid != null) {
      Provider.of<FavoriController>(context, listen: false).fetchFavorites(userId: uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favCtrl = Provider.of<FavoriController>(context);

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Mes favoris')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 80, color: Colors.grey),
              SizedBox(height: 12),
              Text('Connectez-vous pour voir vos favoris.'),
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(Icons.login),
                label: Text('Se connecter'),
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Mes favoris')),
      body: favCtrl.isLoading
          ? Center(child: CircularProgressIndicator())
          : favCtrl.favorites.isEmpty
          ? Center(child: Text('Aucun produit en favori.'))
          : ListView.builder(
        itemCount: favCtrl.favorites.length,
        itemBuilder: (context, i) {
          final prod = favCtrl.favorites[i];
          return Card(
            child: ListTile(
              leading: (prod['images'] != null && prod['images'].isNotEmpty)
                  ? Image.network(prod['images'][0], width: 50, fit: BoxFit.cover)
                  : Icon(Icons.favorite, color: Colors.red),
              title: Text(prod['nom']),
              subtitle: Text('${prod['prix']} €'),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await favCtrl.removeFavorite(userId: userId!, productId: prod['id']);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsPage(productId: prod['id']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
