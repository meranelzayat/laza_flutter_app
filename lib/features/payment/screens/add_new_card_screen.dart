import 'package:flutter/material.dart';
import '../services/cards_firebase_service.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  static const purple = Color(0xFF8F7CFF);

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final _owner = TextEditingController();
  final _number = TextEditingController();
  final _exp = TextEditingController();
  final _cvv = TextEditingController(); // مش هنحفظه
  bool _saveCardInfo = true;
  String _brand = 'mastercard';
  bool _loading = false;

  @override
  void dispose() {
    _owner.dispose();
    _number.dispose();
    _exp.dispose();
    _cvv.dispose();
    super.dispose();
  }

  InputDecoration _deco(String hint) => InputDecoration(
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

  Future<void> _save() async {
    final owner = _owner.text.trim();
    final num = _number.text.trim();
    final exp = _exp.text.trim();

    if (owner.isEmpty || num.isEmpty || exp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await CardsFirebaseService().addCard(
        ownerName: owner,
        cardNumber: num,
        exp: exp,
        brand: _brand,
        // ✅ toggle في الديزاين اسمها Save card info
        // هنستخدمها هنا إنها تعمل الكارت Default أو لأ (زي ما كان عندك)
        saveAsDefault: _saveCardInfo,
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save card error: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _brandChip(String id, String imagePath) {
    final selected = _brand == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _brand = id),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? Colors.deepOrange : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        children: [
          Row(
            children: [
              _brandChip('mastercard', 'assets/images/mastercard.png'),
              const SizedBox(width: 12),
              _brandChip('paypal', 'assets/images/paypal.png'),
              const SizedBox(width: 12),
              _brandChip('bank', 'assets/images/bank.png'),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Card Owner',
              style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          TextField(controller: _owner, decoration: _deco('Mrh Raju')),
          const SizedBox(height: 14),
          const Text('Card Number',
              style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          TextField(
            controller: _number,
            keyboardType: TextInputType.number,
            decoration: _deco('5254 7634 8734 7690'),
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(
                  child: Text('EXP',
                      style: TextStyle(fontWeight: FontWeight.w800))),
              SizedBox(width: 12),
              Expanded(
                  child: Text('CVV',
                      style: TextStyle(fontWeight: FontWeight.w800))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _exp,
                  keyboardType: TextInputType.datetime,
                  decoration: _deco('24/24'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _cvv,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: _deco('7763'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Save card info',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Switch(
                value: _saveCardInfo,
                onChanged: (v) => setState(() => _saveCardInfo = v),
                activeColor: AddNewCardScreen.purple,
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 58,
            child: ElevatedButton(
              onPressed: _loading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AddNewCardScreen.purple,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Save Card',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
