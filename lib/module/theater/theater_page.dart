import 'package:admin_panel/data/model/theater.dart';
import 'package:admin_panel/data/service/theater_service.dart';
import 'package:admin_panel/module/theater/add_dialog.dart';
import 'package:admin_panel/module/theater/edit_theater.dart';
import 'package:flutter/material.dart';

class TheaterManagementPage extends StatefulWidget {
  @override
  _TheaterManagementPageState createState() => _TheaterManagementPageState();
}

class _TheaterManagementPageState extends State<TheaterManagementPage> {
  final TheaterService _theaterService = TheaterService();
  List<Theater> _theaters = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadTheaters();
  }

  Future<void> _loadTheaters() async {
    try {
      final theaters = await _theaterService.getAllTheaters();
      setState(() {
        _theaters = theaters;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading theaters: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d1d1d),
      appBar: AppBar(
        title: Text(
          'MANAGE THEATERS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationColor: Color.fromARGB(255, 46, 45, 45),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 55, 11, 2),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _theaters.length,
                itemBuilder: (context, index) {
                  final theater = _theaters[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(theater.name),
                      subtitle: Text(
                        '${theater.chain}      ${theater.halls.length} halls',
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editTheater(theater),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTheater(theater.id),
                          ),
                        ],
                      ),
                      onTap: () => _viewTheaterDetails(theater),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addTheater,
      ),
    );
  }

  void _viewTheaterDetails(Theater theater) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(theater.name),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Halls:'),
                  ...theater.halls.map(
                    (hall) => ListTile(title: Text(hall.name)),
                  ),
                  SizedBox(width: 10),
                  Text('chain: ${theater.chain}'),
                  SizedBox(height: 10),
                  Text('Address: ${theater.address}'),
                  SizedBox(height: 10),
                  Text('Latitude: ${theater.latitude}'),
                  SizedBox(height: 10),
                  Text('Longitude: ${theater.longitude}'),
                  SizedBox(height: 10),
                  Text('Map URL: ${theater.mapUrl}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  void _editTheater(Theater theater) {
    // Navigate to the theater edit page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TheaterEditPage(theater: theater),
      ),
    );
    print('Edit theater: ${theater.name}');
  }

  void _deleteTheater(String theaterId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Theater'),
            content: Text('Are you sure you want to delete this theater?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
    if (confirm == true) {
      try {
        await _theaterService.deleteTheater(theaterId);
        _loadTheaters();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Theater deleted')));
      } catch (e) {
        print('Error deleting theater: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete theater')));
      }
    }
  }

  void _addTheater() {
    showDialog(
      context: context,
      builder:
          (_) => AddTheater(
            onSubmit: (theater) async {
              await _theaterService.addTheater(theater);
              _loadTheaters();
            },
            title: 'Add New Theater',
          ),
    );
  }
}
