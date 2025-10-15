import 'package:flutter/material.dart';
import 'package:admin_panel/data/model/schedule.dart';

class ScheduleTable extends StatefulWidget {
  final List<MovieSchedule> schedules;
  final Function(String) onDeleteSchedule;

  const ScheduleTable({
    Key? key,
    required this.schedules,
    required this.onDeleteSchedule,
  }) : super(key: key);

  @override
  State<ScheduleTable> createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  @override
  Widget build(BuildContext context) {
    //if no schdules
    if (widget.schedules.isEmpty) {
      return Center(
        child: Text(
          'No schedules found',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return Card(
      color: const Color(0xFF2d2d2d),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Movie Schedules',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'Theater',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Hall',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Date',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Time',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Price',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      'Actions',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows:
                    widget.schedules.map((schedule) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              schedule.theaterName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              schedule.hallName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              _formatDate(schedule.date),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              schedule.time,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              '\$${schedule.ticketPrice.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed:
                                  () => widget.onDeleteSchedule(schedule.id),
                              tooltip: 'Delete Schedule',
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
