import 'package:flutter/material.dart';
import '../services/reviews_firebase_service.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key, required this.productId});
  final String productId;

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _name = TextEditingController();
  final _text = TextEditingController();

  double _rating = 3.0;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _text.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF6F6F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    final text = _text.text.trim();

    if (text.isEmpty) {
      setState(() => _error = 'Please write your experience');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ReviewsFirebaseService().addReview(
        productId: widget.productId,
        name: name.isEmpty ? 'Anonymous' : name,
        text: text,
        rating: _rating,
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = 'Submit failed: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Review',
            style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            TextField(controller: _name, decoration: _dec('Type your name')),
            const SizedBox(height: 14),
            const Text('How was your experience ?',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            TextField(
              controller: _text,
              decoration: _dec('Describe your experience ?'),
              minLines: 5,
              maxLines: 8,
            ),
            const SizedBox(height: 14),
            const Text('Star',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
            Slider(
              value: _rating,
              min: 0,
              max: 5,
              divisions: 10,
              label: _rating.toStringAsFixed(1),
              onChanged: (v) => setState(() => _rating = v),
            ),
            if (_error != null) ...[
              const SizedBox(height: 6),
              Text(_error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12)),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8F7CFF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w800),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
