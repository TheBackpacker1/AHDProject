import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_list_screen.dart';
import 'ProfileScreen.dart';
import 'list_of_sheep_screen.dart';

class HomeScreen extends StatelessWidget {
  final String role;

  const HomeScreen({super.key, required this.role});

  // logout fonction
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Drawer Header
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            // List of Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.blue),
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen()),
                      );
                    },
                  ),
                  if (role == 'admin') ...[
                    ListTile(
                      leading: const Icon(Icons.people, color: Colors.blue),
                      title: const Text('List of Users'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserListScreen()),
                        );
                      },
                    ),
                  ] else ...[
                    ListTile(
                      leading: const Icon(Icons.list, color: Colors.blue),
                      title: const Text('List of Sheep'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ListOfSheepScreen()),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            // Logout Option at the Bottom
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                logout(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: role == 'admin'
            ? ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserListScreen()),
                  );
                },
                child: const Text('List of Users'),
              )
            : const Text('Welcome user!'),
      ),
    );
  }
}
