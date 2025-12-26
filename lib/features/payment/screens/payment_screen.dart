import 'package:flutter/material.dart';
import '../services/cards_firebase_service.dart';
import '../models/payment_card_model.dart';
import 'add_new_card_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  static const purple = Color(0xFF8F7CFF);

  @override
  Widget build(BuildContext context) {
    final service = CardsFirebaseService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
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
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
      ),
      body: StreamBuilder<List<PaymentCardModel>>(
        stream: service.cardsStream(),
        builder: (context, snap) {
          final cards = snap.data ?? [];
          final hasCards = cards.isNotEmpty;

          final defaultCard = hasCards
              ? cards.firstWhere(
                  (c) => c.isDefault,
                  orElse: () => cards.first,
                )
              : null;

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            children: [
              // ✅ Top card (واحد كبير زي الصورة)
              if (defaultCard != null) ...[
                GestureDetector(
                  onTap: () => service.setDefault(defaultCard.id),
                  child: _BigCardPreview(card: defaultCard),
                ),
              ] else ...[
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      'No cards yet',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // ✅ Add new card button
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddNewCardScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: purple),
                  foregroundColor: purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add new card'),
              ),

              const SizedBox(height: 18),

              // ✅ Default card form preview
              if (defaultCard != null) ...[
                Text(
                  'Default card',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.grey.shade800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                _DefaultCardFormPreview(card: defaultCard),

                const SizedBox(height: 16),

                // ✅ Save card info toggle (UI زي الصورة)
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Save card info',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Switch(
                      value: true,
                      onChanged: (_) {},
                      activeColor: purple,
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ✅ Save Card button
                SizedBox(
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      // مفيش حاجة تتسيف هنا لأن الفورم read-only
                      // لو حابة نخليها تعدّل default أو تفتح AddNewCardScreen قوليلي
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saved ✅')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Save Card',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _BigCardPreview extends StatelessWidget {
  const _BigCardPreview({required this.card});
  final PaymentCardModel card;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFF7D56A), Color(0xFFEE5E5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.12),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // owner + brand
          Row(
            children: [
              Expanded(
                child: Text(
                  card.ownerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                card.brand.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Spacer(),

          // masked number (آخر 4 واضح)
          Text(
            card.maskedNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Text(
                card.exp,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              if (card.isDefault)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DefaultCardFormPreview extends StatelessWidget {
  const _DefaultCardFormPreview({required this.card});
  final PaymentCardModel card;

  InputDecoration _deco(BuildContext context, String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(readOnly: true, decoration: _deco(context, card.ownerName)),
        const SizedBox(height: 12),
        TextField(
            readOnly: true, decoration: _deco(context, card.maskedNumber)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                  readOnly: true, decoration: _deco(context, card.exp)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: _deco(context, '***'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
