import 'package:flutter/material.dart';
import '../../products/screens/products_screen.dart';
import '../../orders/services/orders_service.dart';
import '../../orders/screens/orders_screen.dart';

class OrderConfirmedScreen extends StatefulWidget {
  const OrderConfirmedScreen({
    super.key,
    required this.total,
    required this.itemsCount,
  });

  final double total;
  final int itemsCount;

  static const _purple = Color(0xFF8F7CFF);

  @override
  State<OrderConfirmedScreen> createState() => _OrderConfirmedScreenState();
}

class _OrderConfirmedScreenState extends State<OrderConfirmedScreen> {
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _saveOrder();
  }

  Future<void> _saveOrder() async {
    try {
      await OrdersService.createOrder(
        total: widget.total,
        itemsCount: widget.itemsCount,
      );
      if (!mounted) return;
      setState(() => _saved = true);
    } catch (_) {
      // لو حصل error مش هنوقف UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/undraw_order_confirmed_aaw7 1.png',
                      height: 260,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Order Confirmed!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _saved
                          ? 'Your order has been saved ✅'
                          : 'Saving your order...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Go to Orders (بيشتغل بعد ما order يتسجل)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: !_saved
                      ? null
                      : () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OrdersScreen(),
                            ),
                            (route) => false,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.grey.shade700,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Go to Orders',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Continue Shopping
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const ProductsScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OrderConfirmedScreen._purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Continue Shopping',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
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
