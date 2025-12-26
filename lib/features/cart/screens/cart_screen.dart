import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../products/screens/products_screen.dart';
import '../services/cart_firebase_service.dart';
import 'address_screen.dart';
import 'order_confirmed_screen.dart';
import '../../payment/screens/payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static const purple = Color(0xFF8F7CFF);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  AddressResult? _address;

  @override
  Widget build(BuildContext context) {
    final cart = CartFirebaseService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Cart',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProductsScreen()),
              );
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: cart.cartStream(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Cart error: ${snap.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final docs = snap.data?.docs ?? [];
          final items = docs.map((d) => d.data()).toList();

          // ✅ Total qty (عدد القطع الإجمالي)
          final itemsCount = items.fold<int>(
            0,
            (sum, it) => sum + ((it['qty'] ?? 1) as num).toInt(),
          );

          final subtotal = items.fold<double>(
            0,
            (sum, it) =>
                sum +
                ((it['price'] ?? 0) as num).toDouble() *
                    ((it['qty'] ?? 0) as num).toDouble(),
          );

          const shipping = 10.0;
          final total = subtotal + shipping;

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            children: [
              const SizedBox(height: 8),

              // CART ITEMS
              ...docs.map((doc) {
                final it = doc.data();
                final id = (it['productId'] ?? 0) as int;
                final title = (it['title'] ?? '') as String;
                final image = (it['image'] ?? '') as String;
                final price = ((it['price'] ?? 0) as num).toDouble();
                final qty = ((it['qty'] ?? 1) as num).toInt();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CartItemTile(
                    title: title,
                    subtitle: "Nike Sportswear",
                    price: price,
                    qty: qty,
                    imageUrl: image,
                    onInc: () => cart.inc(id),
                    onDec: () => cart.dec(id),
                    onRemove: () => cart.removeItem(id),
                  ),
                );
              }),

              if (docs.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 46, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      Text(
                        'Cart is empty',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 14),

              // Delivery Address
              _SectionHeader(
                title: 'Delivery Address',
                onTap: () async {
                  final result = await Navigator.push<AddressResult>(
                    context,
                    MaterialPageRoute(builder: (_) => const AddressScreen()),
                  );

                  if (!mounted) return;

                  if (result != null) {
                    setState(() => _address = result);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Address saved ✅')),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              _InfoCard(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.location_on_outlined,
                      color: Colors.orange),
                ),
                title: _address?.title ?? 'Add your address',
                subtitle: _address?.subtitle ?? '',
                trailing: const _GreenCheck(),
              ),

              const SizedBox(height: 14),

              // Payment Method
              _SectionHeader(
                title: 'Payment Method',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaymentScreen()),
                  );
                },
              ),
              const SizedBox(height: 8),
              _InfoCard(
                leading: Container(
                  width: 46,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'VISA',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                title: 'Visa Classic',
                subtitle: '**** 7690',
                trailing: const _GreenCheck(),
              ),

              const SizedBox(height: 14),

              // Order Info
              const Text(
                'Order Info',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              _RowPrice(label: 'Subtotal', value: subtotal),
              const SizedBox(height: 6),
              const _RowPrice(label: 'Shipping cost', value: shipping),
              const SizedBox(height: 6),
              _RowPrice(label: 'Total', value: total, bold: true),

              const SizedBox(height: 16),

              // Checkout Button
              SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: docs.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderConfirmedScreen(
                                total: total,
                                itemsCount: itemsCount, // ✅ اتعرفت خلاص
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CartScreen.purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.qty,
    required this.imageUrl,
    required this.onInc,
    required this.onDec,
    required this.onRemove,
  });

  final String title;
  final String subtitle;
  final double price;
  final int qty;
  final String imageUrl;
  final VoidCallback onInc;
  final VoidCallback onDec;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 62,
              height: 62,
              color: Colors.white,
              child: imageUrl.isEmpty
                  ? const Icon(Icons.image_not_supported)
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${price.toStringAsFixed(0)} (+\$4.00 Tax)',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              InkWell(
                onTap: onDec,
                child: const _QtyBtn(icon: Icons.keyboard_arrow_down),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '$qty',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              InkWell(
                onTap: onInc,
                child: const _QtyBtn(icon: Icons.keyboard_arrow_up),
              ),
            ],
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: onRemove,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete_outline),
            ),
          )
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  const _QtyBtn({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _GreenCheck extends StatelessWidget {
  const _GreenCheck();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, size: 14, color: Colors.white),
    );
  }
}

class _RowPrice extends StatelessWidget {
  const _RowPrice(
      {required this.label, required this.value, this.bold = false});
  final String label;
  final double value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
      color: bold ? Colors.black : Colors.grey.shade700,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('\$${value.toStringAsFixed(0)}', style: style),
      ],
    );
  }
}
