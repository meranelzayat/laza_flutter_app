import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/payment_card_model.dart';

class CardsFirebaseService {
  CardsFirebaseService({
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

  CollectionReference<Map<String, dynamic>> get _cardsCol =>
      _db.collection('users').doc(_uid).collection('cards');

  Stream<List<PaymentCardModel>> cardsStream() {
    return _cardsCol.orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs
              .map((d) => PaymentCardModel.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Future<void> addCard({
    required String ownerName,
    required String cardNumber,
    required String exp,
    required String brand,
    required bool saveAsDefault,
  }) async {
    final digits = cardNumber.replaceAll(' ', '').trim();
    final masked = digits.length >= 4
        ? '**** **** **** ${digits.substring(digits.length - 4)}'
        : '****';

    if (saveAsDefault) {
      final current = await _cardsCol.get();
      for (final d in current.docs) {
        await d.reference.set({'isDefault': false}, SetOptions(merge: true));
      }
    }

    await _cardsCol.add({
      'ownerName': ownerName,
      'maskedNumber': masked,
      'exp': exp,
      'brand': brand,
      'isDefault': saveAsDefault,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> setDefault(String cardId) async {
    final current = await _cardsCol.get();
    for (final d in current.docs) {
      await d.reference.set(
        {'isDefault': d.id == cardId},
        SetOptions(merge: true),
      );
    }
  }
}
