import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/review_model.dart';

class ReviewsFirebaseService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _ref(String productId) {
    return _firestore
        .collection('products')
        .doc(productId)
        .collection('reviews');
  }

  Stream<List<ReviewModel>> streamReviews(String productId) {
    return _ref(productId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => ReviewModel.fromDoc(d)).toList());
  }

  Future<void> addReview({
    required String productId,
    required String name,
    required String text,
    required double rating,
  }) async {
    await _ref(productId).add({
      'name': name.trim(),
      'text': text.trim(),
      'rating': rating,
      'userId': _auth.currentUser?.uid,
      // ✅ Timestamp.now عشان يظهر فورًا + مايحصلش مشاكل orderBy
      'createdAt': Timestamp.now(),
    });
  }
}
