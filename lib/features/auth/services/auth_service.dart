import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// ✅ SIGN UP + Save user in Firestore
  Future<UserCredential> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = cred.user!.uid;

    // Save user basic data in Firestore
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email.trim(),
      'name': name ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return cred;
  }

  /// ✅ LOGIN
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// ✅ FORGOT PASSWORD
  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// ✅ LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// ✅ Optional: create/update user profile fields later
  Future<void> updateUserData({
    required String uid,
    Map<String, dynamic> data = const {},
  }) async {
    await _firestore.collection('users').doc(uid).set(
          data,
          SetOptions(merge: true),
        );
  }
}
