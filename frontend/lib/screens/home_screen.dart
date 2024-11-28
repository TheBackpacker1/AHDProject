import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_list_screen.dart';
import 'ProfileScreen.dart';
import 'list_of_sheep_screen.dart';

class HomeScreen extends StatelessWidget {
  final String role;

  const HomeScreen({super.key, required this.role});

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Supprime toutes les données sauvegardées
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implémentez la recherche si nécessaire
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              } else if (value == 'users' && role == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserListScreen()),
                );
              } else if (value == 'sheep' && role == 'user') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ListOfSheepScreen()),
                );
              } else if (value == 'logout') {
                logout(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'profile',
                  child: Text('Profil'),
                ),
                if (role == 'admin')
                  const PopupMenuItem(
                    value: 'users',
                    child: Text('Liste des utilisateurs'),
                  ),
                if (role == 'user')
                  const PopupMenuItem(
                    value: 'sheep',
                    child: Text('Liste des moutons'),
                  ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Se déconnecter'),
                ),
              ];
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Bienvenue sur l\'application!'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Liste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Rester sur Home
          } else if (index == 1) {
            if (role == 'admin') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserListScreen()),
              );
            } else if (role == 'user') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ListOfSheepScreen()),
              );
            }
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
