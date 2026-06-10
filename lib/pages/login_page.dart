import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Image.asset('assets/aes_logo.svg', height: 80),
              const SizedBox(height: 20),
              const Text(
                'AES Warranty',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE7712D)),
              ),
              const SizedBox(height: 8),
              const Text('Powering Trust, Delivering Quality'),
              const SizedBox(height: 40),

              // Google Sign-In Button
              ElevatedButton.icon(
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        final success = await authProvider.signInWithGoogle();
                        if (!mounted) return; // ✅ Added
                        if (success && mounted) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                icon: const Icon(Icons.g_mobiledata, size: 24),
                label: const Text('Continue with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),

              const SizedBox(height: 20),
              const Row(children: [
                Expanded(child: Divider()),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR')),
                Expanded(child: Divider())
              ]),
              const SizedBox(height: 20),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              if (_isOtpSent) ...[
                TextField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    labelText: 'OTP (6 digits)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
                const SizedBox(height: 16),
              ],

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          if (!_isOtpSent) {
                            setState(() => _isLoading = true);
                            final sent = await authProvider
                                .sendOtp(_emailController.text);
                            if (!mounted) return; // ✅ Added
                            setState(() => _isLoading = false);
                            if (sent && mounted) {
                              setState(() => _isOtpSent = true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'OTP sent to your email (demo: 123456)')),
                              );
                            }
                          } else {
                            setState(() => _isLoading = true);
                            final verified = await authProvider.verifyOtp(
                                _emailController.text, _otpController.text);
                            if (!mounted) return; // ✅ Added
                            setState(() => _isLoading = false);
                            if (verified && mounted) {
                              Navigator.pushReplacementNamed(context, '/home');
                            } else if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Invalid OTP')),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE7712D),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isOtpSent ? 'Verify OTP' : 'Send OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
