import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import 'product_details_screen.dart';

import '../../profile/widgets/app_drawer.dart';
import '../../favorites/services/favorites_store.dart';
import '../../favorites/screens/favorites_screen.dart';
import '../../cart/screens/cart_screen.dart';
import '../../profile/screens/profile_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _api = ApiService();
  late Future<List<Product>> _future;

  final _search = TextEditingController();
  String _query = '';

  final List<String> _brands = [
    'All',
    'Adidas',
    'Nike',
    'FILA',
    'Puma',
    'Reebok'
  ];
  int _brandIndex = 0;

  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _future = _api.getProducts();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  // ✅ Search + Brand filter
  List<Product> _filter(List<Product> items) {
    final q = _query.trim().toLowerCase();
    final selectedBrand = _brands[_brandIndex].toLowerCase();

    return items.where((p) {
      final title = p.title.toLowerCase();
      final category = p.categoryName.toLowerCase();

      final matchesSearch =
          q.isEmpty || title.contains(q) || category.contains(q);

      final matchesBrand = selectedBrand == 'all'
          ? true
          : title.contains(selectedBrand) || category.contains(selectedBrand);

      return matchesSearch && matchesBrand; // ✅ لازم ترجع bool
    }).toList(); // ✅ لازم تقفلي where وتحوّليها list
  }

  // ✅ body حسب bottom nav
  Widget _pageByIndex() {
    if (_navIndex == 1) return const FavoritesScreen();
    if (_navIndex == 2) return const CartScreen();
    if (_navIndex == 3) return const ProfileScreen();
    return _homeBody();
  }

  // ✅ Home body (Products)
  Widget _homeBody() {
    return FutureBuilder<List<Product>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Error: ${snap.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _future = _api.getProducts();
                    }),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final all = snap.data ?? [];
        final items = _filter(all);

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP ROW (menu + bag)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => _CircleIcon(
                      icon: Icons.menu,
                      onTap: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  _CircleIcon(
                    icon: Icons.shopping_bag_outlined,
                    onTap: () {
                      // لو عايزة تروحي للتاب بتاع Cart بدل push:
                      setState(() => _navIndex = 2);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const Text(
                'Hello',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              Text(
                'Welcome to Laza.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 14),

              // SEARCH
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _search,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8F7CFF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.mic, color: Colors.white),
                  )
                ],
              ),

              const SizedBox(height: 18),

              // CHOOSE BRAND
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Choose Brand',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 46,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _brands.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final selected = i == _brandIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _brandIndex = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF8F7CFF)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            _brands[i],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: selected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              // NEW ARRIVAL + GRID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'New Arrival',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length.clamp(0, 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final p = items[index];
                  return _ProductCard(
                    p: p,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsScreen(product: p),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
      body: SafeArea(child: _pageByIndex()),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.p, required this.onTap});

  final Product p;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: p.firstImage.isEmpty
                          ? const Icon(Icons.image_not_supported)
                          : Image.network(
                              p.firstImage,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image),
                            ),
                    ),
                  ),

                  // ✅ FAVORITE
                  Positioned(
                    right: 6,
                    top: 6,
                    child: InkWell(
                      onTap: () => FavoritesStore.instance.toggle(p),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AnimatedBuilder(
                          animation: FavoritesStore.instance,
                          builder: (context, _) {
                            final fav =
                                FavoritesStore.instance.isFavorite(p.id);
                            return Icon(
                              fav ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: fav ? Colors.red : Colors.black,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              p.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              '\$${p.price}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon, required this.onTap});

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

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF8F7CFF),
      unselectedItemColor: Colors.grey.shade500,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border), label: 'Wishlist'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined), label: 'Cart'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
