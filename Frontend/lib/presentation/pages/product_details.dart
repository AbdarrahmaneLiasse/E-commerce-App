import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared_preferences/shared_preferences_helper.dart';
import '../controllers/CartController.dart';
import '../controllers/favori_controller.dart';
import '../controllers/product_controller.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;
  const ProductDetailsPage({required this.productId, Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<Map<String, dynamic>> _futureProduct;
  int? userId;
  int quantityInCart = 0; // Quantity for this product in cart
  bool isLoadingQty = true;

  @override
  void initState() {
    super.initState();
    final productCtrl = Provider.of<ProductController>(context, listen: false);
    _futureProduct = productCtrl.fetchProductById(widget.productId);

    _initUserAndCart();
    _initFavoris(); // <--- add this
  }

  void _initFavoris() async {
    int? uid = await SharedPreferencesHelper.getUserId();
    if (uid != null) {
      final favCtrl = Provider.of<FavoriController>(context, listen: false);
      await favCtrl.fetchFavorites(userId: uid);
    }
  }


  Future<void> _initUserAndCart() async {
    int? uid = await SharedPreferencesHelper.getUserId();
    String sessionId = await SharedPreferencesHelper.getOrCreateSessionId();
    final cartCtrl = Provider.of<CartController>(context, listen: false);
    await cartCtrl.fetchCart(userId: uid, sessionId: uid == null ? sessionId : null);

    Map<String, dynamic>? cartItem;
    try {
      cartItem = cartCtrl.cartItems.firstWhere(
            (item) => item['product']['id'] == widget.productId,
      );
    } catch (e) {
      cartItem = null;
    }

    setState(() {
      userId = uid;
      quantityInCart = cartItem != null ? cartItem['quantite'] as int : 0;
      isLoadingQty = false;
    });
  }



  void _updateQuantity(int newQty) async {
    if (isLoadingQty) return; // Prevent double tap

    setState(() => isLoadingQty = true);

    final cartCtrl = Provider.of<CartController>(context, listen: false);
    String sessionId = await SharedPreferencesHelper.getOrCreateSessionId();

    // Avoid unnecessary calls (e.g., tap + twice quickly)
    if (newQty == quantityInCart) {
      setState(() => isLoadingQty = false);
      return;
    }

    if (newQty <= 0) {
      // Remove from cart (if exists)
      Map<String, dynamic>? cartItem;
      try {
        cartItem = cartCtrl.cartItems.firstWhere(
              (item) => item['product']['id'] == widget.productId,
        );
      } catch (e) {
        cartItem = null;
      }
      if (cartItem != null) {
        await cartCtrl.removeCartItem(
          cartItem['id'],
          userId: userId,
          sessionId: userId == null ? sessionId : null,
        );
        setState(() {
          quantityInCart = 0;
        });
      }
    } else {
      // Add/update to cart
      await cartCtrl.addToCart(
        userId: userId,
        sessionId: userId == null ? sessionId : null,
        productId: widget.productId,
        quantite: newQty,
      );
      setState(() {
        quantityInCart = newQty;
      });
    }
    setState(() => isLoadingQty = false);
  }



  @override
  Widget build(BuildContext context) {
    final favoriteCtrl = Provider.of<FavoriController>(context);
    // No need for cartCtrl here, we update state manually
    return Scaffold(
      appBar: AppBar(
        title: Text("Détail du produit"),
        actions: [
          Consumer<FavoriController>(
            builder: (context, favCtrl, _) {
              final isFav = favCtrl.isFavori(widget.productId);
              return FutureBuilder<Map<String, dynamic>>(
                future: _futureProduct,
                builder: (context, snapshot) {
                  // Don't show heart if product not loaded
                  if (!snapshot.hasData) return SizedBox.shrink();
                  final product = snapshot.data!;
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey[400],
                    ),
                    onPressed: () async {
                      int? userId = await SharedPreferencesHelper.getUserId();
                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Connectez-vous pour ajouter aux favoris.")),
                        );
                        return;
                      }
                      await favCtrl.toggleFavori(userId, widget.productId, product);
                    },
                    tooltip: isFav ? 'Retirer des favoris' : 'Ajouter aux favoris',
                  );
                },
              );
            },
          ),

        ],
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }
          final product = snapshot.data!;
          final images = (product['images'] as List?) ?? [];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (images.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      images[0],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 210,
                    ),
                  )
                else
                  Container(
                    height: 210,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(child: Icon(Icons.image, size: 64)),
                  ),
                SizedBox(height: 16),
                Text(product['nom'] ?? '', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text(product['description'] ?? ''),
                SizedBox(height: 12),
                Text("${product['prix']} €", style: TextStyle(fontSize: 20, color: Colors.green)),
                Spacer(),
                Center(
                  child: isLoadingQty
                      ? CircularProgressIndicator()
                      : (quantityInCart == 0)
                      ? ElevatedButton.icon(
                    icon: Icon(Icons.add_shopping_cart),
                    label: Text("Ajouter au panier"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(180, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () => _updateQuantity(1),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.redAccent, size: 28),
                          onPressed: quantityInCart > 0
                              ? () => _updateQuantity(quantityInCart - 1)
                              : null,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '$quantityInCart',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.green, size: 28),
                          onPressed: () => _updateQuantity(quantityInCart + 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
