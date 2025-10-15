import 'package:admin_panel/data/model/promote.dart';
import 'package:admin_panel/module/promote/widget/promote_card.dart';
import 'package:flutter/material.dart';

class CardAction extends StatelessWidget {
  const CardAction({
    super.key,
    required this.promote,
    required this.onEdit,
    required this.onDelete,
  });
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Promote promote;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PromoteCard(promote: promote),
        Positioned(
          top: 8,
          right: 8,
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(
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
