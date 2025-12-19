import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/product_controller.dart';

class Accueil extends StatefulWidget {
  final String? role;
  const Accueil({Key? key, this.role}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<ProductController>(context, listen: false)
        .loadAllProducts();
  });
}


  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, ctrl, _) {
        if (ctrl.isLoadingAll) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctrl.allProducts.isEmpty) {
          return const Center(child: Text("Aucun produit trouvé."));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: ctrl.allProducts.length,
          itemBuilder: (context, i) {
            final prod = ctrl.allProducts[i];
            final imageUrl = (prod['images'] != null && prod['images'].isNotEmpty)
                ? prod['images'][0]
                : null;

            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/product_details',
                  arguments: prod['id'],
                );
              },
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // IMAGE
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      child: imageUrl != null
                          ? Image.network(
                        imageUrl,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        height: 180,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 80, color: Colors.grey),
                      ),
                    ),
                    // PRODUCT INFO
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prod['nom'] ?? '',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            prod['description'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '${prod['prix']} €',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
