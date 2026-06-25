import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'pending_approval_page.dart';
import 'web_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  void _showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    if (isDesktop) return const WebLoginPage();

    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.approvalMessage != null) {
      return PendingApprovalPage(message: authProvider.approvalMessage!);
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Card(
                elevation: 8,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/logo.png',
                        height: 80,
                        width: 80,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.verified,
                          size: 70,
                          color: Color(0xFFE7712D),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'AES Warranty',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE7712D),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Powering Trust, Delivering Quality',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Digital Warranty Management System',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Google Sign-In
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                                  setState(() => _isLoading = true);
                                  final success =
                                      await authProvider.signInWithGoogle();
                                  if (!mounted) return;
                                  setState(() => _isLoading = false);
                                  if (success && mounted) {
                                    // ✅ Force navigation after rebuild
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (mounted) {
                                        Navigator.pushReplacementNamed(
                                            context, '/home');
                                      }
                                    });
                                  } else if (mounted) {
                                    _showMessage(
                                        'Google Sign-In failed. Check internet.',
                                        isError: true);
                                  }
                                },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google_logo.png',
                                height: 24,
                                width: 24,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.g_mobiledata,
                                  size: 24,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Continue with Google',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
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
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => setState(() => _isSignUp = false),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight: _isSignUp
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                fontSize: 18,
                                color: _isSignUp
                                    ? Colors.grey
                                    : const Color(0xFFE7712D),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          TextButton(
                            onPressed: () => setState(() => _isSignUp = true),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: _isSignUp
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 18,
                                color: _isSignUp
                                    ? const Color(0xFFE7712D)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (_isSignUp)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: const TextStyle(fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                          ),
                        ),

                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 28),

                      ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                                setState(() => _isLoading = true);
                                bool success;
                                if (_isSignUp) {
                                  success = await authProvider.signUpWithEmail(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                    _usernameController.text.trim(),
                                  );
                                } else {
                                  success = await authProvider.signInWithEmail(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                                }
                                if (!mounted) return;
                                setState(() => _isLoading = false);
                                if (success && mounted) {
                                  // ✅ Force navigation after rebuild
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted) {
                                      Navigator.pushReplacementNamed(
                                          context, '/home');
                                    }
                                  });
                                } else if (authProvider.approvalMessage !=
                                        null &&
                                    mounted) {
                                  // Pending screen already showing
                                } else if (mounted) {
                                  _showMessage(
                                    _isSignUp
                                        ? 'Sign-up failed. Email may exist or weak password.'
                                        : 'Invalid email or password.',
                                    isError: true,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE7712D),
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isSignUp ? 'Sign Up' : 'Sign In',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
