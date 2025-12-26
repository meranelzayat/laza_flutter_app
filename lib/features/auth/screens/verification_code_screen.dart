import 'package:flutter/material.dart';
import 'new_password_screen.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String email;
  const VerificationCodeScreen({super.key, required this.email});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  final _c3 = TextEditingController();
  final _c4 = TextEditingController();

  String? _error;

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    _c4.dispose();
    super.dispose();
  }

  void _confirmCode() {
    final code = (_c1.text + _c2.text + _c3.text + _c4.text).trim();
    if (code.length != 4) {
      setState(() => _error = 'Enter 4 digits');
      return;
    }

    // Demo OTP: أي 4 أرقام
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewPasswordScreen(email: widget.email),
      ),
    );
  }

  Widget _otpBox(TextEditingController c) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF8F7CFF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Verification Code',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 18),
              Container(
                height: 170,
                width: 170,
                decoration: BoxDecoration(
                  color: purple.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Image.asset(
                    'assets/images/Object.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _otpBox(_c1),
                  _otpBox(_c2),
                  _otpBox(_c3),
                  _otpBox(_c4),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                '00:20  resend confirmation code.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _confirmCode,
                  child: const Text(
                    'Confirm Code',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
