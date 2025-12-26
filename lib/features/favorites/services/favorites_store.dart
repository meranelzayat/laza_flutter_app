import 'package:flutter/foundation.dart';
import '../../products/models/product_model.dart';

class FavoritesStore extends ChangeNotifier {
  FavoritesStore._();
  static final FavoritesStore instance = FavoritesStore._();

  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  bool isFavorite(int productId) {
    return _items.any((p) => p.id == productId);
  }

  void toggle(Product p) {
    final index = _items.indexWhere((x) => x.id == p.id);
    if (index >= 0) {
      _items.removeAt(index);
    } else {
      _items.add(p);
    }
    notifyListeners();
  }

  void remove(int productId) {
    _items.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
