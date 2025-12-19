import 'package:flutter/material.dart';
import '../../shared_preferences/shared_preferences_helper.dart';

class ComptePage extends StatefulWidget {
  const ComptePage({Key? key}) : super(key: key);

  @override
  State<ComptePage> createState() => _ComptePageState();
}

class _ComptePageState extends State<ComptePage> {
  int? userId;
  String? userEmail;
  String? userRole;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final id = await SharedPreferencesHelper.getUserId();
    final email = await SharedPreferencesHelper.getEmail();
    final role = await SharedPreferencesHelper.getRole();
    setState(() {
      userId = id;
      userEmail = email;
      userRole = role;
    });
  }

  void _logout() async {
    await SharedPreferencesHelper.clear();
    setState(() {
      userId = null;
      userEmail = null;
      userRole = null;
    });
    // Optionally: navigate to home or login page after logout
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    // If not logged in, show redirect page (or a login prompt)
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Compte')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline, size: 80, color: Colors.grey),
              SizedBox(height: 12),
              Text('Vous n\'êtes pas connecté.', style: TextStyle(fontSize: 18)),
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(Icons.login),
                label: Text('Se connecter'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      );
    }

    // If logged in, show account page
    return Scaffold(
      appBar: AppBar(title: Text('Mon Compte')),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                Icon(Icons.account_circle, size: 100, color: Colors.green),
                SizedBox(height: 10),
                Text(userEmail ?? '', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                if (userRole != null) Text('Rôle : $userRole', style: TextStyle(fontSize: 16)),
                SizedBox(height: 30),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_basket_outlined),
            title: Text('Mes commandes'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to orders page, pass userId if needed
              Navigator.pushNamed(context, '/my_orders', arguments: {'userId': userId});
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite_border),
            title: Text('Mes favoris'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/my_favorites');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Déconnexion', style: TextStyle(color: Colors.red)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
