import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          backgroundColor: isError ? Colors.red : Colors.green),
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/aes_logo.svg', height: 70),
                  const SizedBox(height: 12),
                  const Text(
                    'AES Warranty',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE7712D)),
                  ),
                  const SizedBox(height: 28),

                  // Google Sign-In with official logo
                  OutlinedButton.icon(
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            setState(() => _isLoading = true);
                            final success =
                                await authProvider.signInWithGoogle();
                            setState(() => _isLoading = false);
                            if (!mounted) return;
                            if (success) {
                              Navigator.pushReplacementNamed(context, '/home');
                            } else {
                              _showMessage('Google Sign-In failed',
                                  isError: true);
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
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(children: [
                    Expanded(child: Divider()),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR')),
                    Expanded(child: Divider()),
                  ]),
                  const SizedBox(height: 16),

                  // Toggle Sign In / Sign Up
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
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            setState(() => _isLoading = true);
                            bool success;
                            if (_isSignUp) {
                              success = await authProvider.signUpWithEmail(
                                _emailController.text,
                                _passwordController.text,
                                _usernameController.text,
                              );
                            } else {
                              success = await authProvider.signInWithEmail(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                            setState(() => _isLoading = false);
                            if (!mounted) return;
                            if (success) {
                              Navigator.pushReplacementNamed(context, '/home');
                            } else if (authProvider.approvalMessage != null) {
                              // pending screen already showing
                            } else {
                              _showMessage(
                                  _isSignUp
                                      ? 'Sign-up failed'
                                      : 'Invalid credentials',
                                  isError: true);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE7712D),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Text(_isSignUp ? 'Sign Up' : 'Sign In',
                            style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
