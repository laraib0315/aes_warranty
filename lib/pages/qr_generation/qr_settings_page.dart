import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrSettingsPage extends StatefulWidget {
  const QrSettingsPage({super.key});

  @override
  State<QrSettingsPage> createState() => _QrSettingsPageState();
}

class _QrSettingsPageState extends State<QrSettingsPage> {
  String _purpose = 'Ceiling Fans';
  String _size = 'Multiples QR Generation';
  int _defaultLimit = 35;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _purpose = prefs.getString('qr_purpose') ?? 'Ceiling Fans';
      _size = prefs.getString('qr_size') ?? 'Multiples QR Generation';
      _defaultLimit = prefs.getInt('qr_default_limit') ?? 35;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('qr_purpose', _purpose);
    await prefs.setString('qr_size', _size);
    await prefs.setInt('qr_default_limit', _defaultLimit);
    if (!mounted) return; // ✅ Added
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Settings'),
        actions: [
          IconButton(onPressed: _saveSettings, icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Purpose'),
              subtitle: Text(_purpose),
              trailing: DropdownButton<String>(
                value: _purpose,
                items: const [
                  DropdownMenuItem(
                      value: 'Ceiling Fans',
                      child: Text('Ceiling Fans (QR + Barcode)')),
                  DropdownMenuItem(
                      value: 'Others', child: Text('Others (Only QR)')),
                ],
                onChanged: (val) => setState(() => _purpose = val!),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Generation Size'),
              subtitle: Text(_size),
              trailing: DropdownButton<String>(
                value: _size,
                items: const [
                  DropdownMenuItem(
                      value: 'Single QR Only', child: Text('Single QR Only')),
                  DropdownMenuItem(
                      value: 'Multiples QR Generation',
                      child: Text('Multiples QR Generation')),
                ],
                onChanged: (val) => setState(() => _size = val!),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Default Limit Per Page'),
              subtitle: Text('$_defaultLimit QRs'),
              trailing: SizedBox(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  controller:
                      TextEditingController(text: _defaultLimit.toString()),
                  onChanged: (val) => _defaultLimit = int.tryParse(val) ?? 35,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Note: A4 page max 54 QRs for 1x1 inch.\nFor Ceiling Fans, barcode will be included.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
