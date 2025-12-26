import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../../cart/services/cart_firebase_service.dart';
import '../../cart/screens/cart_screen.dart';

// ✅ Reviews imports
import '../models/review_model.dart';
import '../services/reviews_firebase_service.dart';
import 'reviews_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _cart = CartFirebaseService();
  int _imgIndex = 0;
  int _sizeIndex = 2; // default L

  final sizes = const ['S', 'M', 'L', 'XL', '2XL'];

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final images = p.images.isNotEmpty ? p.images : [''];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top image + appbar icons
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _TopIcon(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.pop(context),
                    ),
                    _TopIcon(
                      icon: Icons.shopping_bag_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    height: 320,
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: (images[_imgIndex].isEmpty)
                        ? const Center(child: Icon(Icons.image_not_supported))
                        : Image.network(
                            images[_imgIndex],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Center(child: Icon(Icons.broken_image)),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // thumbnails
              SizedBox(
                height: 64,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length.clamp(0, 6),
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final selected = i == _imgIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _imgIndex = i),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF8F7CFF)
                                : Colors.transparent,
                            width: 2,
                          ),
                          color: Colors.grey.shade100,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: images[i].isEmpty
                              ? const Icon(Icons.image_not_supported)
                              : Image.network(
                                  images[i],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.categoryName.isEmpty ? "Men's" : p.categoryName,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            p.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Price',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                        const SizedBox(height: 6),
                        Text(
                          '\$${p.price}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Size row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Size',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w900)),
                    Text('Size Guide',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(sizes.length, (i) {
                    final selected = i == _sizeIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _sizeIndex = i),
                      child: Container(
                        width: 52,
                        height: 44,
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF8F7CFF)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            sizes[i],
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: selected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text('Description',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  p.description.isEmpty ? 'No description.' : p.description,
                  style: TextStyle(
                      fontSize: 12.5, height: 1.5, color: Colors.grey.shade700),
                ),
              ),

              const SizedBox(height: 18),

              // ✅ Reviews header + View all
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    const Text('Reviews',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w900)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        final productId = p.id.toString();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ReviewsScreen(productId: productId)),
                        );
                      },
                      child: const Text('View all'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ✅ Preview review card (زي الصورة)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: _ReviewsPreview(productId: p.id.toString()),
              ),

              const SizedBox(height: 18),

              // Add to cart
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await _cart.addToCart(widget.product);
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart ✅')),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cart error: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8F7CFF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Add to Cart'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewsPreview extends StatelessWidget {
  const _ReviewsPreview({required this.productId});
  final String productId;

  String _dateText(DateTime d) {
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

    return StreamBuilder<List<ReviewModel>>(
      stream: svc.streamReviews(productId),
      builder: (context, snap) {
        final list = snap.data ?? const <ReviewModel>[];

        if (snap.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 92,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        if (list.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFEDE7F6),
                  child: Icon(Icons.person, color: Color(0xFF8F7CFF)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'No reviews yet. Be the first one!',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          );
        }

        final r = list.first;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFEDE7F6),
                child: Icon(Icons.person, color: Color(0xFF8F7CFF)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            r.name.isEmpty ? 'Anonymous' : r.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                        ),
                        Text(
                          r.rating.toStringAsFixed(1),
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 12),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'rating',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (i) {
                        final filled = r.rating >= (i + 1);
                        return Icon(
                          filled ? Icons.star : Icons.star_border,
                          size: 14,
                          color: const Color(0xFFFFC107),
                        );
                      }),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          _dateText(r.createdAt.toDate()),
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      r.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopIcon extends StatelessWidget {
  const _TopIcon({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }
}
