import 'package:flutter/material.dart';
import '../models/sheep_model.dart';
import '../services/sheep_service.dart';

class ListOfSheepScreen extends StatefulWidget {
  const ListOfSheepScreen({super.key});

  @override
  _ListOfSheepScreenState createState() => _ListOfSheepScreenState();
}

class _ListOfSheepScreenState extends State<ListOfSheepScreen> {
  final SheepService _sheepService = SheepService();
  final List<Sheep> _sheepList = [];

  final TextEditingController _necklaceIDController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _raceController = TextEditingController();
  final TextEditingController _healthStatusController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  bool _isLoading = false;
  bool _isVaccinated = false;

  @override
  void initState() {
    super.initState();
    _fetchSheepList();
  }

  @override
  void dispose() {
    _necklaceIDController.dispose();
    _ageController.dispose();
    _raceController.dispose();
    _healthStatusController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // Fetch the sheep list
  Future<void> _fetchSheepList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Sheep> fetchedList = await _sheepService.fetchSheep();
      print(fetchedList);
      setState(() {
        _sheepList.clear();
        _sheepList.addAll(fetchedList);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching sheep list: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to submit sheep details
  Future<void> _submitSheepDetails() async {
    if (_necklaceIDController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _raceController.text.isEmpty ||
        _healthStatusController.text.isEmpty ||
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Sheep newSheep = Sheep(
        id: DateTime.now().toString(),
        necklaceID: _necklaceIDController.text,
        age: _ageController.text,
        race: _raceController.text,
        healthStatus: _healthStatusController.text,
        weight: _weightController.text,
        vaccinated: _isVaccinated,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _sheepService.addSheep(newSheep);

      setState(() {
        _sheepList.add(newSheep);
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sheep added successfully!')),
      );

      // Clear fields
      _necklaceIDController.clear();
      _ageController.clear();
      _raceController.clear();
      _healthStatusController.clear();
      _weightController.clear();
      setState(() {
        _isVaccinated = false; // Reset vaccination status after submitting
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding sheep: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });

      // Close the dialog after adding the sheep
      Navigator.of(context).pop();
    }
  }

  // Function to show the "Add Sheep" dialog
  void _showAddSheepDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Sheep'),
          content: SizedBox(
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _necklaceIDController,
                    decoration: const InputDecoration(labelText: 'Necklace ID'),
                  ),
                  TextField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _raceController,
                    decoration: const InputDecoration(labelText: 'Race'),
                  ),
                  TextField(
                    controller: _healthStatusController,
                    decoration:
                        const InputDecoration(labelText: 'Health Status'),
                  ),
                  TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isVaccinated,
                        onChanged: (bool? value) {
                          setState(() {
                            _isVaccinated = value ?? false;
                          });
                        },
                      ),
                      const Text('Vaccinated'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submitSheepDetails,
                          child: const Text('Add Sheep'),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //Delete a sheep

  Future<void> _deleteSheep(String id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _sheepService.deleteSheep(id);
      setState(() {
        _sheepList.removeWhere((sheep) => sheep.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sheep deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete sheep: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

//Update Sheep
  Future<void> _updateSheepDetails(String id) async {
    if (_necklaceIDController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _raceController.text.isEmpty ||
        _healthStatusController.text.isEmpty ||
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Sheep updatedSheep = Sheep(
        id: id,
        necklaceID: _necklaceIDController.text,
        age: _ageController.text,
        race: _raceController.text,
        healthStatus: _healthStatusController.text,
        weight: _weightController.text,
        vaccinated: _isVaccinated,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _sheepService.updateSheep(id, updatedSheep);

      setState(() {
        int index = _sheepList.indexWhere((sheep) => sheep.id == id);
        if (index != -1) {
          _sheepList[index] = updatedSheep;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sheep updated successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating sheep: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showUpdateSheepDialog(Sheep sheep) {
    // Pre-fill the text fields with the selected sheep's data
    _necklaceIDController.text = sheep.necklaceID;
    _ageController.text = sheep.age;
    _raceController.text = sheep.race;
    _healthStatusController.text = sheep.healthStatus;
    _weightController.text = sheep.weight;
    _isVaccinated = sheep.vaccinated;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Sheep'),
          content: SizedBox(
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _necklaceIDController,
                    decoration: const InputDecoration(labelText: 'Necklace ID'),
                  ),
                  TextField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _raceController,
                    decoration: const InputDecoration(labelText: 'Race'),
                  ),
                  TextField(
                    controller: _healthStatusController,
                    decoration:
                        const InputDecoration(labelText: 'Health Status'),
                  ),
                  TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(labelText: 'Weight'),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isVaccinated,
                        onChanged: (bool? value) {
                          setState(() {
                            _isVaccinated = value ?? false;
                          });
                        },
                      ),
                      const Text('Vaccinated'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _updateSheepDetails(sheep.id),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of Sheep')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _sheepList.isEmpty
                ? const Text('No sheep found')
                : SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Necklace ID')),
                        DataColumn(label: Text('Age')),
                        DataColumn(label: Text('Race')),
                        DataColumn(label: Text('Health Status')),
                        DataColumn(label: Text('Weight')),
                        DataColumn(label: Text('Vaccinated')),
                        DataColumn(label: Text('Actions')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: _sheepList.map((sheep) {
                        return DataRow(
                          cells: [
                            DataCell(Text(sheep.necklaceID)),
                            DataCell(Text(sheep.age.toString())),
                            DataCell(Text(sheep.race)),
                            DataCell(Text(sheep.healthStatus)),
                            DataCell(Text(sheep.weight.toString())),
                            DataCell(Text(sheep.vaccinated ? 'Yes' : 'No')),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateSheepDialog(sheep);
                                },
                              ),
                            ),
                            DataCell(IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteSheep(sheep.id);
                              },
                            ))
                          ],
                        );
                      }).toList(),
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSheepDialog,
        child: const Icon(Icons.add),
        tooltip: 'Add Sheep',
      ),
    );
  }
}
