import 'package:admin_panel/data/model/theater.dart';
import 'package:admin_panel/data/service/theater_service.dart';
import 'package:flutter/material.dart';

class TheaterEditPage extends StatefulWidget {
  const TheaterEditPage({super.key, required this.theater});

  final Theater theater;

  @override
  State<TheaterEditPage> createState() => _TheaterEditPageState();
}

class _TheaterEditPageState extends State<TheaterEditPage> {
  final TheaterService _theaterService = TheaterService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Theater')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Theater Name'),
              controller: TextEditingController(text: widget.theater.name),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Chain'),
              controller: TextEditingController(text: widget.theater.chain),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Address'),
              controller: TextEditingController(text: widget.theater.address),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Cover URL'),
              controller: TextEditingController(text: widget.theater.coverUrl),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Latitude'),
              controller: TextEditingController(
                text: widget.theater.latitude.toString(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Longitude'),
              controller: TextEditingController(
                text: widget.theater.longitude.toString(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Map URL'),
              controller: TextEditingController(text: widget.theater.mapUrl),
            ),
            SizedBox(height: 32),
            ElevatedButton(onPressed: _saveTheater, child: Text('Save')),
          ],
        ),
      ),
    );
  }

  void _saveTheater() {
    // Save the edited theater information
    _theaterService.updateTheater(widget.theater);
    Navigator.pop(context);
  }
}
