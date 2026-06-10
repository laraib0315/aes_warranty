import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class WebLoginPage extends StatefulWidget {
  const WebLoginPage({super.key});

  @override
  State<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, const Color(0xFFE7712D).withOpacity(0.05)],
          ),
        ),
        child: Row(
          children: [
            // Left side - Branding (only on desktop)
            if (isDesktop)
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFE7712D),
                        const Color(0xFFC85711)
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.verified_outlined,
                            size: 80, color: Color(0xFFE7712D)),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'AES Warranty',
                        style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Powering Trust, Delivering Quality',
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: const Text(
                          'Digital Warranty Management System\nfor Electrical Products',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.white60),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Right side - Login Form
            Expanded(
              flex: isDesktop ? 1 : 2,
              child: Center(
                child: Container(
                  width: isDesktop ? 480 : double.infinity,
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isDesktop)
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE7712D).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.verified_outlined,
                                  size: 48, color: Color(0xFFE7712D)),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'AES Warranty',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE7712D)),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to manage warranties',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      // Google Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                                  final success =
                                      await authProvider.signInWithGoogle();
                                  if (!mounted) return;
                                  if (success && mounted) {
                                    Navigator.pushReplacementNamed(
                                        context, '/web_home');
                                  }
                                },
                          icon: Image.network(
                            'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                            height: 24,
                            width: 24,
                          ),
                          label: const Text(
                            'Continue with Google',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('OR',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Email Field
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'you@example.com',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      if (_isOtpSent)
                        TextField(
                          controller: _otpController,
                          decoration: InputDecoration(
                            labelText: 'OTP (6 digits)',
                            hintText: 'Enter 6-digit code',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                        ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                                  if (!_isOtpSent) {
                                    setState(() => _isLoading = true);
                                    final sent = await authProvider
                                        .sendOtp(_emailController.text);
                                    if (!mounted) return;
                                    setState(() => _isLoading = false);
                                    if (sent && mounted) {
                                      setState(() => _isOtpSent = true);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('OTP sent: 123456')),
                                      );
                                    }
                                  } else {
                                    setState(() => _isLoading = true);
                                    final verified =
                                        await authProvider.verifyOtp(
                                      _emailController.text,
                                      _otpController.text,
                                    );
                                    if (!mounted) return;
                                    setState(() => _isLoading = false);
                                    if (verified && mounted) {
                                      Navigator.pushReplacementNamed(
                                          context, '/web_home');
                                    } else if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Invalid OTP')),
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE7712D),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(_isOtpSent ? 'Verify OTP' : 'Send OTP',
                                  style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
