import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static const purple = Color(0xFF8F7CFF);

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  String? _error;
  bool _obscure = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _validEmail {
    final e = _email.text.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e);
  }

  bool get _validName => _name.text.trim().length >= 3;

  String get _passwordStrength {
    final p = _password.text;
    if (p.length < 6) return 'Weak';
    final hasUpper = p.contains(RegExp(r'[A-Z]'));
    final hasLower = p.contains(RegExp(r'[a-z]'));
    final hasNum = p.contains(RegExp(r'[0-9]'));
    final hasSym = p.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\]]'));
    final score = [hasUpper, hasLower, hasNum, hasSym].where((x) => x).length;

    if (p.length >= 10 && score >= 3) return 'Strong';
    if (score >= 2) return 'Medium';
    return 'Weak';
  }

  Color get _strengthColor {
    switch (_passwordStrength) {
      case 'Strong':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  Future<void> _signup() async {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final pass = _password.text;

    if (!_validName || !_validEmail || pass.isEmpty) {
      setState(() => _error = 'Please enter valid data');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await AuthService().signUp(
        email: email,
        password: pass,
        name: name, // ✅ مهم عشان يتسجل في Firestore
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _dec(String label, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: const UnderlineInputBorder(),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: purple, width: 1.5),
      ),
      labelStyle: const TextStyle(
        fontSize: 12,
        color: purple,
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      suffixIcon: suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ back circle
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),

              const SizedBox(height: 22),

              const Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ),

              const SizedBox(height: 40),

              // Username
              TextField(
                controller: _name,
                onChanged: (_) => setState(() {}),
                decoration: _dec(
                  'Username',
                  suffix: _validName
                      ? const Icon(Icons.check, color: Colors.green, size: 18)
                      : null,
                ),
              ),

              const SizedBox(height: 22),

              // Password
              TextField(
                controller: _password,
                onChanged: (_) => setState(() {}),
                obscureText: _obscure,
                decoration: _dec(
                  'Password',
                  suffix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _passwordStrength,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _strengthColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          size: 20,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Email
              TextField(
                controller: _email,
                onChanged: (_) => setState(() {}),
                keyboardType: TextInputType.emailAddress,
                decoration: _dec(
                  'Email Address',
                  suffix: _validEmail
                      ? const Icon(Icons.check, color: Colors.green, size: 18)
                      : null,
                ),
              ),

              const SizedBox(height: 28),

              // Remember me
              Row(
                children: [
                  const Text('Remember me', style: TextStyle(fontSize: 12)),
                  const Spacer(),
                  Switch(
                    value: _rememberMe,
                    onChanged: (v) => setState(() => _rememberMe = v),
                    activeColor: purple,
                  ),
                ],
              ),

              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],

              const Spacer(),

              // Sign Up button (bottom)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _loading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Sign Up'),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Already have an account? Login',
                    style:
                        TextStyle(color: purple, fontWeight: FontWeight.w700),
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
