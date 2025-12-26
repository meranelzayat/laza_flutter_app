import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;
  const NewPasswordScreen({super.key, required this.email});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  bool _loading = false;
  String? _error;
  bool _ob1 = true;
  bool _ob2 = true;

  @override
  void dispose() {
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final p1 = _pass.text.trim();
    final p2 = _confirm.text.trim();

    if (p1.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }
    if (p1 != p2) {
      setState(() => _error = 'Passwords do not match');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    // Firebase reset الحقيقي بيكون من لينك الإيميل
    // فهنا هنرسل reset email (عملي) + UI مطابق للتصميم
    try {
      await AuthService().forgotPassword(widget.email);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Reset link sent to your email. Open it to set password.'),
        ),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (_) {
      setState(() => _error = 'Something went wrong');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _dec(String label, bool obscure, VoidCallback toggle) {
    return InputDecoration(
      labelText: label,
      border: const UnderlineInputBorder(),
      suffixIcon: IconButton(
        onPressed: toggle,
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
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
                'New Password',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _pass,
                obscureText: _ob1,
                decoration: _dec('Password', _ob1, () {
                  setState(() => _ob1 = !_ob1);
                }),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _confirm,
                obscureText: _ob2,
                decoration: _dec('Confirm Password', _ob2, () {
                  setState(() => _ob2 = !_ob2);
                }),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please write your new password.',
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
                  onPressed: _loading ? null : _resetPassword,
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Reset Password',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
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
