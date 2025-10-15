import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/data/model/promote.dart';
import 'package:admin_panel/data/service/promote_service.dart';

class AddPromoteDialog extends StatefulWidget {
  final Map<String, dynamic>? promoteData;
  final Function(Map<String, dynamic>)? onSubmit;
  final String title;
  const AddPromoteDialog({
    super.key,
    this.promoteData,
    this.onSubmit,
    required this.title,
  });

  @override
  State<AddPromoteDialog> createState() => _AddPromoteDialogState();
}

class _AddPromoteDialogState extends State<AddPromoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController();
  String _selectedChain = "Legend";

  final promoteService = PromoteService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Promotion"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Promotion Name"),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: "Image URL"),
              ),
              DropdownButtonFormField<String>(
                value: _selectedChain,
                decoration: const InputDecoration(labelText: "Chain"),
                items:
                    ["Legend", "Major", "Prime"]
                        .map(
                          (chain) => DropdownMenuItem(
                            value: chain,
                            child: Text(chain),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => _selectedChain = val!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final id =
                  FirebaseFirestore.instance.collection("promotions").doc().id;

              final promote = Promote(
                id: id,
                name: _nameController.text,
                imageUrl:
                    _imageController.text.isNotEmpty
                        ? _imageController.text
                        : "assets/default_promo.jpg",
                description: _descController.text,
                chain: _selectedChain,
              );

              await promoteService.addPromotion(promote.toMap());
              Navigator.pop(context);
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
