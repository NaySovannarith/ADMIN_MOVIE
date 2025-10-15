import 'package:admin_panel/data/model/hall.dart';
import 'package:admin_panel/data/model/movie.dart';
import 'package:admin_panel/data/model/schedule.dart';
import 'package:admin_panel/data/model/theater.dart';
import 'package:admin_panel/data/view_model/available_time_view_model.dart';
import 'package:admin_panel/module/schedule/widget/movie_selector.dart';
import 'package:admin_panel/module/schedule/widget/schedule_tableV2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SchedulePageV2 extends StatefulWidget {
  const SchedulePageV2({super.key});
  @override
  State<SchedulePageV2> createState() => _ScheduleState();
}

class _ScheduleState extends State<SchedulePageV2> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Movie> _movies = [];
  List<Theater> _theaters = [];
  TheaterHall? hall;
  Movie? _selectedMovie;
  Theater? _selectedTheater;
  bool _isLoading = true;
  DateTime? _selectedDate;
  TheaterHall? _selectedHall;
  double? _selectPrice;
  List<MovieSchedule> _schedules = [];
  final List<String> _selectedTimes = [];

  //first loading in page
  @override
  void initState() {
    super.initState();
    _loadMovies();
    _loadTheaters();
    _loadSchedules();
  }

  // get movies from firestore
  Future<void> _loadMovies() async {
    try {
      final snapshot = await _firestore.collection('movies').get();
      setState(() {
        _movies =
            snapshot.docs.map((doc) {
              final data = doc.data();
              return Movie(
                id: doc.id,
                title: data['title'] ?? '',
                description: data['description'] ?? '',
                posterUrl: data['posterUrl'] ?? '',
                releaseDate: data['releaseDate'] ?? '',
                genres: List<String>.from(data['genres'] ?? []),
                rating: data['rating'] ?? '',
                duration: (data['duration'] as num?)?.toDouble() ?? 0.0,
              );
            }).toList();
        if (_movies.isNotEmpty) {
          _selectedMovie = _movies.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      //  print("Error loading movies: $e");
      setState(() => _isLoading = false);
    }
  }

  //get theaters form firestore
  Future<void> _loadTheaters() async {
    try {
      final snapshot = await _firestore.collection('theaters').get();
      print("Found ${snapshot.docs.length} theaters");
      setState(() {
        _theaters =
            snapshot.docs.map((doc) {
              try {
                return Theater.fromDocument(doc);
              } catch (e) {
                return Theater(
                  id: doc.id,
                  name: 'Unknown',
                  chain: 'Unknown',
                  halls: [],
                  address: '',
                  coverUrl: '',
                  latitude: 0.0,
                  longitude: 0.0,
                  mapUrl: '',
                );
              }
            }).toList();

        if (_theaters.isNotEmpty) {
          _selectedTheater = _theaters.first;
        }
      });
    } catch (e) {
      print("Error loading theaters: $e");
    }
  }

  // get endpoint schedules from 'schedules' collection
  Future<void> _loadSchedules() async {
    try {
      final snapshot = await _firestore.collection('schedules').get();
      setState(() {
        _schedules =
            snapshot.docs.map((doc) {
              final data = doc.data();
              return MovieSchedule(
                id: doc.id,
                movieId: data['movieId'] ?? '',
                movieTitle: data['movieTitle'] ?? '',
                theaterId: data['theaterId'] ?? '',
                theaterName: data['theaterName'] ?? '',
                hallId: data['hallId'] ?? '',
                hallName: data['hallName'] ?? '',
                date: (data['date'] as Timestamp).toDate(),
                time: data['time'] ?? '',
                ticketPrice: (data['ticketPrice'] as num?)?.toDouble() ?? 0.0,
                posterUrl: data['posterUrl'] ?? '',
              );
            }).toList();
      });
    } catch (e) {
      print("Error loading schedules: $e");
    }
  }

  // Save schedules to 'schedules'collection
  Future<void> _saveSchedules() async {
    if (_selectedMovie == null ||
        _selectedTheater == null ||
        _selectedHall == null ||
        _selectedDate == null ||
        _selectedTimes.isEmpty ||
        _selectPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      for (String time in _selectedTimes) {
        final docRef = _firestore.collection('schedules').doc();
        final newSchedule = MovieSchedule(
          id: docRef.id,
          movieId: _selectedMovie!.id,
          movieTitle: _selectedMovie!.title,
          posterUrl: _selectedMovie!.posterUrl,
          theaterId: _selectedTheater!.id,
          theaterName: _selectedTheater!.name,
          hallId: _selectedHall!.id,
          hallName: _selectedHall!.name,
          date: _selectedDate!,
          time: time,
          ticketPrice: _selectPrice!,
        );
        await docRef.set(newSchedule.toMap());
      }
      // Refresh schedules after saving
      await _loadSchedules();
      // Clear selection
      setState(() {
        _selectedTimes.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving schedules: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteSchedule(String scheduleId) async {
    try {
      await _firestore.collection('schedules').doc(scheduleId).delete();
      await _loadSchedules(); // Refresh the list

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Schedule deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting schedule: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Widget _buildAddScheduleCard() {
    final now = DateTime.now();
    final next7days = List.generate(
      7,
      (i) => DateTime(now.year, now.month, now.day + i),
    );

    return Card(
      color: const Color(0xFF2d2d2d),
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New Schedule",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Theater Dropdown
            DropdownButton<Theater>(
              value: _selectedTheater,
              hint: const Text(
                "Select Theater",
                style: TextStyle(color: Colors.white70),
              ),
              items:
                  _theaters.map((theater) {
                    return DropdownMenuItem(
                      value: theater,
                      child: Text(
                        theater.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
              onChanged:
                  (t) => setState(() {
                    _selectedTheater = t;
                    _selectedHall = null;
                  }),
              dropdownColor: const Color(0xFF2d2d2d),
              isExpanded: true,
            ),
            const SizedBox(height: 12),
            // Hall
            if (_selectedTheater != null)
              DropdownButton<TheaterHall>(
                value: _selectedHall,
                hint: const Text(
                  "Select Hall",
                  style: TextStyle(color: Colors.white70),
                ),
                items:
                    _selectedTheater!.halls.map((hall) {
                      return DropdownMenuItem(
                        value: hall,
                        child: Text(
                          '${hall.name}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                onChanged: (h) => setState(() => _selectedHall = h),
                dropdownColor: const Color(0xFF2d2d2d),
                isExpanded: true,
              ),
            const SizedBox(height: 12),
            // Date Selection
            const Text(
              "Select Date:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  next7days.map((date) {
                    final selected =
                        _selectedDate != null &&
                        _selectedDate!.year == date.year &&
                        _selectedDate!.month == date.month &&
                        _selectedDate!.day == date.day;

                    return ChoiceChip(
                      label: Text(
                        _formatDate(date),
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.white70,
                        ),
                      ),
                      selected: selected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _selectedDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                            );
                          } else if (selected) {
                            _selectedDate = null;
                          }
                        });
                      },
                      selectedColor: Colors.blue[800],
                      backgroundColor: const Color(0xFF3d3d3d),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 12),

            // Time Selection
            const Text(
              "Select Times:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  availableTimes.map((time) {
                    final selected = _selectedTimes.contains(time);
                    return ChoiceChip(
                      label: Text(
                        time,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.white70,
                        ),
                      ),
                      selected: selected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _selectedTimes.add(time);
                          } else {
                            _selectedTimes.remove(time);
                          }
                        });
                      },
                      selectedColor: Colors.blue[800],
                      backgroundColor: const Color(0xFF3d3d3d),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 12),
            // Price Input
            TextField(
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Ticket Price',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF3d3d3d),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (val) {
                setState(() {
                  _selectPrice = double.tryParse(val);
                });
              },
            ),
            const SizedBox(height: 16),
            // Save Button
            ElevatedButton.icon(
              onPressed: _saveSchedules,

              label: const Text("Save Schedules"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'SCHEDULE MANAGEMENT',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 58, 1, 1),
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      MovieSelector(
                        movies: _movies,
                        selectedMovie: _selectedMovie,
                        onChanged: (movie) {
                          setState(() {
                            _selectedMovie = movie;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      _buildAddScheduleCard(),
                      SizedBox(height: 20),
                      ScheduleTable(
                        schedules:
                            _selectedMovie != null
                                ? _schedules
                                    .where(
                                      (s) => s.movieId == _selectedMovie!.id,
                                    )
                                    .toList()
                                : _schedules,
                        onDeleteSchedule: _deleteSchedule,
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
