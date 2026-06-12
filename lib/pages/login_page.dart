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

  void _showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('AES Warranty',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        final success = await authProvider.signInWithGoogle();
                        setState(() => _isLoading = false);
                        if (!mounted) return;
                        if (success) {
                          // Navigate only if route exists
                          if (ModalRoute.of(context)?.settings.name !=
                              '/home') {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            _showMessage('Already logged in');
                          }
                        } else {
                          _showMessage('Google Sign-In failed', isError: true);
                        }
                      },
                child: const Text('Sign in with Google'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              if (_isOtpSent)
                TextField(
                  controller: _otpController,
                  decoration:
                      const InputDecoration(labelText: 'OTP (6 digits)'),
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        if (!_isOtpSent) {
                          final sent =
                              await authProvider.sendOtp(_emailController.text);
                          setState(() => _isLoading = false);
                          if (!mounted) return;
                          if (sent) {
                            setState(() => _isOtpSent = true);
                            _showMessage('OTP sent: 123456');
                          } else {
                            _showMessage('Failed to send OTP', isError: true);
                          }
                        } else {
                          final verified = await authProvider.verifyOtp(
                              _emailController.text, _otpController.text);
                          setState(() => _isLoading = false);
                          if (!mounted) return;
                          if (verified) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            _showMessage('Invalid OTP', isError: true);
                          }
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(_isOtpSent ? 'Verify OTP' : 'Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
