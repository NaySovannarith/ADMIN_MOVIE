import 'package:admin_panel/data/model/promote.dart';
import 'package:admin_panel/data/service/promote_service.dart';
import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({super.key, required this.promote});
  final Promote promote;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final PromoteService _promoteService = PromoteService();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Promotion'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Title'),
            controller: TextEditingController(text: widget.promote.name),
            onChanged: (value) {
              widget.promote.name = value;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Description'),
            controller: TextEditingController(text: widget.promote.description),
            onChanged: (value) {
              widget.promote.description = value;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Image URL'),
            controller: TextEditingController(text: widget.promote.imageUrl),
            onChanged: (value) {
              widget.promote.imageUrl = value;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(onPressed: _savePromote, child: Text('Save')),
      ],
    );
  }

  void _savePromote() {
    // Save the edited promote information
    _promoteService.updatePromote(widget.promote);
    Navigator.pop(context);
  }
}
