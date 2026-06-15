import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'pending_approval_page.dart';

class WebLoginPage extends StatefulWidget {
  const WebLoginPage({super.key});

  @override
  State<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.approvalMessage != null) {
      return PendingApprovalPage(message: authProvider.approvalMessage!);
    }

    final isDesktop = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              const Color(0xFFE7712D).withValues(alpha: 0.05)
            ],
          ),
        ),
        child: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE7712D), Color(0xFFC85711)],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/aes_logo.svg',
                          height: 100, color: Colors.white),
                      const SizedBox(height: 30),
                      const Text(
                        'AES Warranty',
                        style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      const Text('Powering Trust, Delivering Quality',
                          style:
                              TextStyle(fontSize: 18, color: Colors.white70)),
                      const SizedBox(height: 40),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Digital Warranty Management System\nfor Electrical Products',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.white60),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                        color: Colors.black.withValues(alpha: 0.05),
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
                            Image.asset('assets/aes_logo.svg', height: 60),
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
                      const Text('Welcome Back',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Sign in to manage warranties',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 32),

                      // Google Sign-In with official logo
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                                  setState(() => _isLoading = true);
                                  final success =
                                      await authProvider.signInWithGoogle();
                                  setState(() => _isLoading = false);
                                  if (!mounted) return;
                                  if (success) {
                                    Navigator.pushReplacementNamed(
                                        context, '/web_home');
                                  }
                                },
                          icon: Image.network(
                            'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                            height: 24,
                            width: 24,
                          ),
                          label: const Text('Continue with Google',
                              style: TextStyle(fontSize: 16)),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Row(children: [
                        Expanded(child: Divider()),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('OR')),
                        Expanded(child: Divider()),
                      ]),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => setState(() => _isSignUp = false),
                            child: Text('Sign In',
                                style: TextStyle(
                                    fontWeight: _isSignUp
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    fontSize: 16)),
                          ),
                          const SizedBox(width: 20),
                          TextButton(
                            onPressed: () => setState(() => _isSignUp = true),
                            child: Text('Sign Up',
                                style: TextStyle(
                                    fontWeight: _isSignUp
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 16)),
                          ),
                        ],
                      ),
                      if (_isSignUp)
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                          ),
                        ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                                  setState(() => _isLoading = true);
                                  bool success;
                                  if (_isSignUp) {
                                    success =
                                        await authProvider.signUpWithEmail(
                                      _emailController.text,
                                      _passwordController.text,
                                      _usernameController.text,
                                    );
                                  } else {
                                    success =
                                        await authProvider.signInWithEmail(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                  }
                                  setState(() => _isLoading = false);
                                  if (!mounted) return;
                                  if (success) {
                                    Navigator.pushReplacementNamed(
                                        context, '/web_home');
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
                              : Text(_isSignUp ? 'Sign Up' : 'Sign In',
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
