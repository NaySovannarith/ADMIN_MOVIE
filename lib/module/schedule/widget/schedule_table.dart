import 'package:admin_panel/data/model/movie.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class schedule_table extends StatefulWidget {
  const schedule_table({super.key, required List<Movie> movies})
    : _movies = movies;

  final List<Movie> _movies;

  @override
  State<schedule_table> createState() => _schedule_tableState();
}

class _schedule_tableState extends State<schedule_table> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 200),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        decoration: BoxDecoration(
          color: Color(0xFF3d3d3d),
          borderRadius: BorderRadius.circular(8),
        ),
        columns: const [
          DataColumn2(
            label: Text(
              'Title',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn2(
            label: Text(
              'ID',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn2(
            label: Text(
              'RATING',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn2(
            label: Text(
              'RELEASEDATE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        rows:
            widget._movies.map((movie) {
              return DataRow2(
                cells: [
                  DataCell(Text(movie.title)),
                  DataCell(Text(movie.id)),
                  DataCell(Text(movie.rating)),
                  DataCell(Text(movie.releaseDate)),
                ],
              );
            }).toList(),
      ),
    );
  }
}
