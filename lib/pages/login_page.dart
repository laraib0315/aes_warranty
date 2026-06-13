import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'web_login_page.dart'; // Web login page ko import kiya

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
    // 1. Check karein ke screen size desktop (PC/Laptop) ka hai ya nahi
    final isDesktop = MediaQuery.of(context).size.width > 800;

    if (isDesktop) {
      return const WebLoginPage(); // Agar desktop hai to professional web login screen dikhao
    }

    // 2. Agar mobile size hai to neeche wala simple mobile layout render hoga
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

              // Google Sign-In Button
              ElevatedButton(
                onPressed: authProvider.isLoading || _isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        final success = await authProvider.signInWithGoogle();
                        setState(() => _isLoading = false);
                        if (!mounted) return;
                        if (success) {
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

              // Email Input Field
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // OTP Input Field (Sirf tab dikhega jab OTP send ho chuka ho)
              if (_isOtpSent)
                TextField(
                  controller: _otpController,
                  decoration:
                      const InputDecoration(labelText: 'OTP (6 digits)'),
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                ),
              const SizedBox(height: 16),

              // OTP Send/Verify Button
              ElevatedButton(
                onPressed: authProvider.isLoading || _isLoading
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
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isOtpSent ? 'Verify OTP' : 'Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
