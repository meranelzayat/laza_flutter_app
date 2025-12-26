import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review_model.dart';
import '../services/reviews_firebase_service.dart';
import 'add_review_screen.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key, required this.productId});
  final String productId;

  double _avg(List<ReviewModel> list) {
    if (list.isEmpty) return 0;
    final sum = list.fold<double>(0, (a, b) => a + b.rating);
    return sum / list.length;
  }

  String _dateText(Timestamp ts) {
    final d = ts.toDate();
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${d.day} ${m[d.month - 1]}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final svc = ReviewsFirebaseService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reviews',
            style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: StreamBuilder<List<ReviewModel>>(
        stream: svc.streamReviews(productId),
        builder: (context, snap) {
          final reviews = snap.data ?? const <ReviewModel>[];
          final avg = _avg(reviews);

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${reviews.length} Reviews',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${avg.toStringAsFixed(1)} ',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                    const Icon(Icons.star, size: 14, color: Color(0xFFFFC107)),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddReviewScreen(productId: productId),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Add Review'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7043),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: snap.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          itemCount: reviews.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, i) {
                            final r = reviews[i];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Color(0xFFEDE7F6),
                                  child: Icon(Icons.person,
                                      color: Color(0xFF8F7CFF)),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              r.name.isEmpty
                                                  ? 'Anonymous'
                                                  : r.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            r.rating.toStringAsFixed(1),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text('rating',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: List.generate(5, (x) {
                                          final filled = r.rating >= (x + 1);
                                          return Icon(
                                            filled
                                                ? Icons.star
                                                : Icons.star_border,
                                            size: 14,
                                            color: const Color(0xFFFFC107),
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time,
                                              size: 14,
                                              color: Colors.grey.shade500),
                                          const SizedBox(width: 4),
                                          Text(
                                            _dateText(r.createdAt),
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        r.text,
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.4,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
