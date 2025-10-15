import 'package:admin_panel/data/view_model/genre_view_model.dart';
import 'package:admin_panel/data/view_model/rate_view_model.dart';
import 'package:flutter/material.dart';

class MovieFormDialog extends StatefulWidget {
  final Map<String, dynamic>? movie;
  final Function(Map<String, dynamic>) onSubmit;
  final String title;

  MovieFormDialog({this.movie, required this.onSubmit, required this.title});

  @override
  _MovieFormDialogState createState() => _MovieFormDialogState();
}

class _MovieFormDialogState extends State<MovieFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  List<String> _selectedGenres = [];

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _formData.addAll(widget.movie!);
      _selectedGenres = List<String>.from(widget.movie!['genres'] ?? []);
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

                _buildTextField('Title', 'title', true),
                SizedBox(height: 16),

                _buildTextField(
                  'Description',
                  'description',
                  false,
                  maxLines: 3,
                ),
                SizedBox(height: 16),

                _buildTextField('Poster URL', 'posterUrl', true),
                SizedBox(height: 16),
                TextFormField(
                  controller: TextEditingController(
                    text: _formData['releaseDate']?.toString() ?? '',
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Release Date',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[50],
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2050),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _formData['releaseDate'] =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a release date';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                // Rating Selection (NEW - Replaced TextField)
                Text('Rating', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      availableRatings.map((rating) {
                        final isSelected = _formData['rating'] == rating;
                        return ChoiceChip(
                          label: Text(rating),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _formData['rating'] = rating;
                              } else {
                                _formData['rating'] = '';
                              }
                            });
                          },
                        );
                      }).toList(),
                ),
                SizedBox(height: 16),

                _buildTextField(
                  'Duration (minutes)',
                  'duration',
                  false,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                Text('Genres', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      availableGenres.map((genre) {
                        final isSelected = _selectedGenres.contains(genre);
                        return FilterChip(
                          label: Text(genre),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedGenres.add(genre);
                              } else {
                                _selectedGenres.remove(genre);
                              }
                              _formData['genres'] = _selectedGenres;
                            });
                          },
                        );
                      }).toList(),
                ),

                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
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

  Widget _buildTextField(
    String label,
    String field,
    bool isRequired, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      initialValue: _formData[field]?.toString(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
      onSaved: (value) => _formData[field] = value,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formData['genres'] = _selectedGenres;
      if (_formData['duration'] != null) {
        _formData['duration'] =
            double.tryParse(_formData['duration'].toString()) ?? 0.0;
      }
      widget.onSubmit(_formData);
      Navigator.pop(context);
    }
  }
}
