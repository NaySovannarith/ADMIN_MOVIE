import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:admin_panel/data/model/user.dart';

class UserPage extends StatefulWidget {
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text(
          'User Management',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 55, 11, 2),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found'));
          }

          final users =
              snapshot.data!.docs
                  .map((doc) => MyUser.fromFirestore(doc))
                  .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 89, 3, 3),
                  child: Text(
                    (user.fullName.isNotEmpty
                        ? user.fullName[0].toUpperCase()
                        : '?'),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  user.fullName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.email, style: TextStyle(color: Colors.white)),
                    if (user.phoneNumber != null)
                      Text(
                        'Phone: ${user.phoneNumber}',
                        style: TextStyle(color: Colors.white),
                      ),
                    if (user.createdAt != null)
                      Text(
                        'Joined: ${DateFormat('MMM dd, yyyy').format(user.createdAt!)}',
                        style: TextStyle(color: Colors.white),
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(user.id),
                ),
                onTap: () => _showUserDetails(context, user),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteUser(String userId) {
    _firestore.collection('users').doc(userId).delete();
  }

  void _showUserDetails(BuildContext context, MyUser user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('User Details'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${user.fullName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Email: ${user.email}'),
                  if (user.phoneNumber != null)
                    Text('Phone: ${user.phoneNumber}'),
                  if (user.dateOfBirth != null)
                    Text('DOB: ${user.dateOfBirth}'),
                  if (user.createdAt != null)
                    Text(
                      'Member since: ${DateFormat('MMM dd, yyyy').format(user.createdAt!)}',
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }
}
