import 'package:flutter/foundation.dart';
import '../../products/models/product_model.dart';

class CartItem {
  final Product product;
  int qty;

  CartItem({required this.product, this.qty = 1});
}

class CartStore extends ChangeNotifier {
  CartStore._();
  static final CartStore instance = CartStore._();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void add(Product p) {
    final i = _items.indexWhere((x) => x.product.id == p.id);
    if (i >= 0) {
      _items[i].qty++;
    } else {
      _items.add(CartItem(product: p, qty: 1));
    }
    notifyListeners();
  }

  void removeProduct(int productId) {
    _items.removeWhere((x) => x.product.id == productId);
    notifyListeners();
  }

  void inc(int productId) {
    final i = _items.indexWhere((x) => x.product.id == productId);
    if (i >= 0) {
      _items[i].qty++;
      notifyListeners();
    }
  }

  void dec(int productId) {
    final i = _items.indexWhere((x) => x.product.id == productId);
    if (i >= 0) {
      _items[i].qty--;
      if (_items[i].qty <= 0) _items.removeAt(i);
      notifyListeners();
    }
  }

  double get subTotal {
    double sum = 0;
    for (final it in _items) {
      sum += (it.product.price.toDouble() * it.qty);
    }
    return sum;
  }

  double get shipping => _items.isEmpty ? 0 : 10;

  double get total => subTotal + shipping;

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
