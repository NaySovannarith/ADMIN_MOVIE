import 'package:admin_panel/data/model/movie.dart';
import 'package:admin_panel/module/movie/widget/movie_card.dart';
import 'package:flutter/material.dart';

class MovieCardWithActions extends StatelessWidget {
  final Movie movie;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MovieCardWithActions({
    required this.movie,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MovieCard(movie: movie),
        Positioned(
          top: 8,
          right: 8,
          child: PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
          ),
        ),
      ],
    );
  }
}
