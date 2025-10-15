import 'package:admin_panel/data/model/promote.dart';
import 'package:admin_panel/data/service/promote_service.dart';
import 'package:admin_panel/module/promote/widget/add_dialog.dart';
import 'package:admin_panel/module/promote/widget/card_action.dart';
import 'package:admin_panel/module/promote/widget/edit_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PromotePage extends StatefulWidget {
  const PromotePage({super.key});

  @override
  State<PromotePage> createState() => _PromotePageState();
}

class _PromotePageState extends State<PromotePage> {
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text(
          'PROMOTION MANAGEMENT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationColor: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 55, 11, 2),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('promotions').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Promotions Available',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }
                final promotions = snapshot.data!.docs;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: promotions.length,
                  itemBuilder: (context, index) {
                    final promo = promotions[index];
                    final promoData = promo.data() as Map<String, dynamic>;
                    final promotion = Promote(
                      id: promo.id,
                      name: promoData['name'] ?? '',
                      imageUrl: promoData['imageUrl'] ?? '',
                      description: promoData['description'] ?? '',
                      chain: promoData['chain'] ?? '',
                    );
                    //  return PromoteCard(promote: promotion);
                    return CardAction(
                      promote: promotion,
                      onEdit: () {
                        _editPromoteDialog(promotion);
                      },
                      onDelete: () async {
                        await _firestore
                            .collection('promotions')
                            .doc(promotion.id)
                            .delete();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Promotion deleted')),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AddPromoteDialog(
                  title: ' Promotion',
                  onSubmit: (data) => PromoteService().addPromotion(data),
                ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 88, 3, 3),

        tooltip: 'Add Promotion',
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  void _editPromoteDialog(Promote promote) {
    showDialog(
      context: context,
      builder: (context) => EditDialog(promote: promote),
    );
  }
}
