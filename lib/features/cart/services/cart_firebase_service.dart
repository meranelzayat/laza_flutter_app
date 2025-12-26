import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../products/models/product_model.dart';

class CartFirebaseService {
  CartFirebaseService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) throw Exception('Not logged in');
    return u.uid;
  }

  CollectionReference<Map<String, dynamic>> get _itemsCol =>
      _db.collection('users').doc(_uid).collection('cart');

  Future<void> addToCart(Product p, {int qty = 1}) async {
    final doc = _itemsCol.doc(p.id.toString());

    await _db.runTransaction((tx) async {
      final snap = await tx.get(doc);
      final currentQty = (snap.data()?['qty'] ?? 0) as int;

      tx.set(
          doc,
          {
            'productId': p.id,
            'title': p.title,
            'price': p.price,
            'image': p.firstImage,
            'qty': currentQty + qty,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true));
    });
  }

  Future<void> removeItem(int productId) async {
    await _itemsCol.doc(productId.toString()).delete();
  }

  Future<void> inc(int productId) async {
    final doc = _itemsCol.doc(productId.toString());
    await doc.set({'qty': FieldValue.increment(1)}, SetOptions(merge: true));
  }

  Future<void> dec(int productId) async {
    final doc = _itemsCol.doc(productId.toString());

    await _db.runTransaction((tx) async {
      final snap = await tx.get(doc);
      final qty = (snap.data()?['qty'] ?? 0) as int;
      if (qty <= 1) {
        tx.delete(doc);
      } else {
        tx.update(
            doc, {'qty': qty - 1, 'updatedAt': FieldValue.serverTimestamp()});
      }
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> cartStream() {
    return _itemsCol.orderBy('updatedAt', descending: true).snapshots();
  }
}
