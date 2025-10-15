import 'package:admin_panel/data/model/promote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PromoteService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addPromotion(Map<String, dynamic> data) async {
    await _firestore.collection('promotions').add(data);
  }

  Future<void> updatePromotion(String id, Map<String, dynamic> data) async {
    await _firestore.collection('promotions').doc(id).update(data);
  }

  Future<void> deletePromotion(String id) async {
    await _firestore.collection('promotions').doc(id).delete();
  }

  Future<List<Promote>> getPromotions() async {
    final snapshot = await _firestore.collection('promotions').get();
    return snapshot.docs
        .map((doc) => Promote.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> updatePromote(Promote promote) async {
    // if (promote.id != null) {
    //   await _firestore
    //       .collection('promotions')
    //       .doc(promote.id)
    //       .update(promote.toMap());
    // }
    try {
      await _firestore
          .collection('promotions')
          .doc(promote.id)
          .update(promote.toMap());
    } catch (e) {
      print('Error updating promotion: $e');
      throw Exception('Failed to update promotion');
    }
  }
}
