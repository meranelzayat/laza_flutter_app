import 'package:flutter/material.dart';
import '../services/address_firebase_service.dart';

class AddressResult {
  final String title; // "Chhatak, Sunamgonj 12/8AB"
  final String subtitle; // "Sylhet"
  const AddressResult({required this.title, required this.subtitle});
}

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _svc = AddressFirebaseService();

  final _name = TextEditingController(text: 'Mrh Raju');
  final _country = TextEditingController(text: 'Bangladesh');
  final _city = TextEditingController(text: 'Sylhet');
  final _phone = TextEditingController(text: '+880 1453-987533');
  final _address = TextEditingController(text: 'Chhatak, Sunamgonj 12/8AB');

  bool _primary = true;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _country.dispose();
    _city.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint) => InputDecoration(
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
    if (_loading) return;

    setState(() => _loading = true);
    try {
      await _svc.saveAddress(
        name: _name.text.trim(),
        country: _country.text.trim(),
        city: _city.text.trim(),
        phone: _phone.text.trim(),
        addressLine: _address.text.trim(),
        isPrimary: _primary,
      );

      if (!mounted) return;

      // رجّعي العنوان للـ CartScreen
      Navigator.pop(
        context,
        AddressResult(
          title: _address.text.trim(),
          subtitle: _city.text.trim(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Address error: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF8F7CFF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Address',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Name',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    TextField(controller: _name, decoration: _dec('Name')),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Country',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              TextField(
                                  controller: _country,
                                  decoration: _dec('Country')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('City',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              TextField(
                                  controller: _city, decoration: _dec('City')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text('Phone Number',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    TextField(
                        controller: _phone, decoration: _dec('Phone Number')),
                    const SizedBox(height: 14),
                    const Text('Address',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    TextField(
                        controller: _address, decoration: _dec('Address')),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Save as primary address',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        Switch(
                          value: _primary,
                          activeColor: Colors.green,
                          onChanged: (v) => setState(() => _primary = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(_loading ? 'Saving...' : 'Save Address'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
