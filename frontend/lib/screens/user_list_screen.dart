import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'add_user_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Méthode pour récupérer les utilisateurs
  void _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final users = await ApiService.getUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la récupération des utilisateurs.';
        _isLoading = false;
      });
    }
  }

  // Méthode pour mettre à jour la liste après l'ajout d'un utilisateur
  void _refreshUsers() {
    _fetchUsers();
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des utilisateurs'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return ListTile(
                      title: Text('${user['name']} ${user['lastName']}'),
                      subtitle: Text(user['email']),
                      trailing: Text(user['role']),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final userAdded = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddUserScreen(),
            ),
          );
          // Vérifier si un utilisateur a été ajouté, puis rafraîchir la liste
          if (userAdded == true) {
            _refreshUsers();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
