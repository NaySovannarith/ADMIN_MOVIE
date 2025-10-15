// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class UserService {
//   final _db = FirebaseFirestore.instance;

//   Future<List<User>> fetchUsers() async {
//     final snapshot = await _db.collection('users').get();
//     return snapshot.docs
//         .map((doc) => User.fromFirestore(doc.data(), doc.id))
//         .toList();
//   }
// }
