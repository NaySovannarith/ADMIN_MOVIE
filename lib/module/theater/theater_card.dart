import 'package:admin_panel/data/model/theater.dart';
import 'package:flutter/material.dart';

class TheaterCard extends StatefulWidget {
  const TheaterCard({super.key, required this.theater});
  final Theater theater;
  @override
  State<TheaterCard> createState() => _TheaterCardState();
}

class _TheaterCardState extends State<TheaterCard> {
  @override
  Widget build(BuildContext context) {
    return Card();
  }
}
