import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String name;
  final String text;
  final double rating;
  final String? userId;
  final Timestamp createdAt;

  ReviewModel({
    required this.id,
    required this.name,
    required this.text,
    required this.rating,
    required this.createdAt,
    this.userId,
  });

  factory ReviewModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ReviewModel(
      id: doc.id,
      name: (data['name'] ?? '').toString(),
      text: (data['text'] ?? '').toString(),
      rating:
          (data['rating'] is num) ? (data['rating'] as num).toDouble() : 0.0,
      userId: data['userId']?.toString(),
      createdAt: (data['createdAt'] as Timestamp?) ?? Timestamp.now(),
    );
  }
}
