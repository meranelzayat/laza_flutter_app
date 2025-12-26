import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Account Information')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(user?.email ?? 'No email'),
            const SizedBox(height: 16),
            const Text('UID', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(user?.uid ?? 'No uid'),
          ],
        ),
      ),
    );
  }
}
