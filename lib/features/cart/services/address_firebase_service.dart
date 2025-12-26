import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressFirebaseService {
  AddressFirebaseService({
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

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('users').doc(_uid).collection('addresses');

  Future<String> saveAddress({
    required String name,
    required String country,
    required String city,
    required String phone,
    required String addressLine,
    required bool isPrimary,
  }) async {
    final doc = _col.doc(); // auto id
    await doc.set({
      'name': name,
      'country': country,
      'city': city,
      'phone': phone,
      'addressLine': addressLine,
      'isPrimary': isPrimary,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }
}
