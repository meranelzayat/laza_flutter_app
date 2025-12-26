import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersService {
  static Future<void> createOrder({
    required double total,
    required int itemsCount,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .add({
      'total': total,
      'itemsCount': itemsCount,
      'status': 'pending',
      'createdAt': Timestamp.now(), // ✅ مهم
    });
  }
}
