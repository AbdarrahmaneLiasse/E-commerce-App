import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/favoritePage.dart';
import 'package:provider/provider.dart';
import 'accuieilPage.dart';  // Unified accueil page
import 'cartPage.dart';
import 'comptePage.dart';
import 'manage_products.dart';
import '../controllers/CartController.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({Key? key}) : super(key: key);

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get the role passed from AuthPage
    final String? role = ModalRoute.of(context)?.settings.arguments as String?;
    final bool isCoop = role == "COOPERATION";

    // Dynamically build pages and items based on role
    final List<Widget> pages = [
      Accueil(role: role),
      if (isCoop) ManageProductsPage(),
      FavoriPage(),
      CartPage(),
      ComptePage(),
    ];

    final List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
      if (isCoop) const BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: "Gérer"),
      const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoris"),
      const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Panier"),
      const BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Compte"),
    ];

    // Ensure _selectedIndex is valid
    if (_selectedIndex >= pages.length) _selectedIndex = 0;

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: items,
      ),
    );
  }
}
