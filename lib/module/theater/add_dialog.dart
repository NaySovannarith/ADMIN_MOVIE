import 'package:admin_panel/data/model/hall.dart';
import 'package:admin_panel/data/model/theater.dart';
import 'package:flutter/material.dart';

class AddTheater extends StatefulWidget {
  final Map<String, dynamic>? theater;
  final Function(Theater)? onSubmit;
  final String title;
  const AddTheater({
    super.key,
    this.theater,
    this.onSubmit,
    this.title = 'Add Theater',
  });

  @override
  State<AddTheater> createState() => _AddTheaterState();
}

class _AddTheaterState extends State<AddTheater> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  final List<String> _chains = ['Legend', 'Major', 'Prime'];
  String _name = '';
  List<Map<String, dynamic>> _halls = [];

  @override
  void initState() {
    super.initState();
    if (widget.theater != null) {
      _name = widget.theater!['name'] ?? '';
      _formData['chain'] = widget.theater!['chain'] ?? '';
      _halls = List<Map<String, dynamic>>.from(widget.theater!['halls'] ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildTextField('Theater Name', 'name', true),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _formData['chain'],
                  decoration: InputDecoration(labelText: 'Chain'),
                  items:
                      _chains
                          .map(
                            (chain) => DropdownMenuItem(
                              value: chain,
                              child: Text(chain),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _formData['chain'] = value;
                    });
                  },
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                ),

                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _halls.add({'id': DateTime.now().toString(), 'name': ''});
                    });
                  },
                  child: Text('Add Hall'),
                ),
                SizedBox(height: 16),
                ..._halls.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> hall = entry.value;
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: hall['name'],
                          decoration: InputDecoration(labelText: 'Hall Name'),
                          onChanged: (value) {
                            setState(() {
                              _halls[index]['name'] = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Hall name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _halls.removeAt(index);
                          });
                        },
                      ),
                    ],
                  );
                }),
                SizedBox(height: 16),
                _buildTextField('Cover URL', 'coverUrl', true),
                SizedBox(height: 16),
                _buildTextField('Address', 'address', true),
                _buildTextField('Latitude', 'latitude', true),
                _buildTextField('Longitude', 'longitude', true),
                _buildTextField('Map URL', 'mapUrl', false),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 16),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('Add'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final theater = Theater(
        id: '', // Firestore will automatically get one
        name: _formData['name'],
        chain: _formData['chain'],
        halls: _halls.map((h) => TheaterHall.fromMap(h)).toList(),
        address: _formData['address'] ?? '',
        coverUrl: _formData['coverUrl'] ?? '',
        latitude: double.tryParse(_formData['latitude'] ?? '') ?? 0.0,
        longitude: double.tryParse(_formData['longitude'] ?? '') ?? 0.0,
        mapUrl: _formData['mapUrl'] ?? '',
      );

      if (widget.onSubmit != null) {
        widget.onSubmit!(theater);
      }
      Navigator.pop(context);
    }
    print('theater is added, Form Data: $_formData, Halls: $_halls');
  }

  _buildTextField(
    String label,
    String key,
    bool isRequired, {
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: _formData[key] ?? '',
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
      onSaved: (value) {
        _formData[key] = value;
      },
    );
  }
}
