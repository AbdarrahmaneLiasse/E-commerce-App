import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/CartController.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartCtrl = Provider.of<CartController>(context);

    // Properly extract price and quantity for total calculation
    double totalPrice = 0;
    int totalQuantity = 0;

    for (final item in cartCtrl.cartItems) {
      final product = item['product'] ?? item;
      final price = (product['prix'] as num?)?.toDouble() ?? 0.0;
      final qte = (item['quantite'] ?? 1) as int;
      totalPrice += price * qte;
      totalQuantity += qte;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Mon Panier')),
      body: cartCtrl.cartItems.isEmpty
          ? Center(child: Text('Votre panier est vide.'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartCtrl.cartItems.length,
              itemBuilder: (context, i) {
                final item = cartCtrl.cartItems[i];
                final product = item['product'] ?? item;
                final images = (product['images'] as List?) ?? [];
                final imageUrl = images.isNotEmpty ? images[0] : null;
                final price = (product['prix'] as num?)?.toDouble() ?? 0.0;
                final quantite = (item['quantite'] ?? 1) as int;
                final total = price * quantite;

                return Card(
                  margin: const EdgeInsets.only(bottom: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imageUrl != null
                              ? Image.network(imageUrl, width: 64, height: 64, fit: BoxFit.cover)
                              : Container(
                            width: 64,
                            height: 64,
                            color: Colors.grey[200],
                            child: Icon(Icons.image, size: 32, color: Colors.grey),
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['nom'] ?? '',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text('Prix: ${price.toStringAsFixed(2)} €', style: TextStyle(color: Colors.green[700])),
                              SizedBox(height: 2),
                              Text('Qté: $quantite'),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text('${total.toStringAsFixed(2)} €', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await cartCtrl.removeCartItem(item['id']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Article supprimé')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // --- Cart Summary & "Commander" Button ---
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))]
            ),
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total articles:', style: TextStyle(fontSize: 15)),
                    Text('$totalQuantity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total à payer:', style: TextStyle(fontSize: 17)),
                    Text('${totalPrice.toStringAsFixed(2)} €', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green[700])),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
                    ),
                    icon: Icon(Icons.shopping_bag),
                    label: Text("Commander"),
                    onPressed: () {
                      // Place order logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Commande passée !')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
