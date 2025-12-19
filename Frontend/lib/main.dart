import 'package:flutter/material.dart';
import 'package:frontend/presentation/controllers/favori_controller.dart';
import 'package:frontend/presentation/pages/comptePage.dart';
import 'package:frontend/presentation/pages/favoritePage.dart';
import 'package:frontend/presentation/pages/product_details.dart';
import 'package:provider/provider.dart';
import 'data/cart_repository.dart';
import 'data/favori_repository.dart';
import 'presentation/controllers/CartController.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/product_controller.dart';
import 'presentation/pages/email_selectorUI.dart';
import 'presentation/pages/manage_products.dart';
import 'presentation/pages/homeShellUn.dart'; // << It's usually better to import after the other pages
import 'data/product_repository.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ProductController(ProductRepository())),
        ChangeNotifierProvider(create: (_) => CartController(CartRepository())),
        ChangeNotifierProvider(
          create: (_) => FavoriController(FavoriRepository()),
        ),
      ],
      child: const MyApp(), // << add const
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      routes: {
        '/HomeShell': (context) => HomeShell(),
        '/manageProducts': (context) => ManageProductsPage(),
        '/compte': (context) => ComptePage(),
        //'/my_orders': (context) => CommandesPage(),
        '/my_favorites': (context) => FavoriPage(),
        '/login': (context) => EmailSelectorUI(),
        '/product_details': (context) {
          final id = ModalRoute.of(context)!.settings.arguments as int;
          return ProductDetailsPage(productId: id);
        },
      },
        home: HomeShell(),

    );
  }
}
