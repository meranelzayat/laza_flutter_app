import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentCardModel {
  final String id;
  final String ownerName;
  final String maskedNumber; // **** **** **** 7690
  final String exp; // 24/24
  final String brand; // visa/mastercard/paypal/bank
  final bool isDefault;
  final Timestamp createdAt;

  const PaymentCardModel({
    required this.id,
    required this.ownerName,
    required this.maskedNumber,
    required this.exp,
    required this.brand,
    required this.isDefault,
    required this.createdAt,
  });

  factory PaymentCardModel.fromMap(String id, Map<String, dynamic> map) {
    return PaymentCardModel(
      id: id,
      ownerName: (map['ownerName'] ?? '') as String,
      maskedNumber: (map['maskedNumber'] ?? '') as String,
      exp: (map['exp'] ?? '') as String,
      brand: (map['brand'] ?? 'visa') as String,
      isDefault: (map['isDefault'] ?? false) as bool,
      createdAt: (map['createdAt'] as Timestamp?) ?? Timestamp.now(),
    );
  }
}
