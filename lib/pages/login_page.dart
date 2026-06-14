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
          backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    if (isDesktop) {
      return const WebLoginPage();
    }

    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.approvalMessage != null) {
      return PendingApprovalPage(message: authProvider.approvalMessage!);
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/aes_logo.svg', height: 80),
              const SizedBox(height: 20),
              const Text('AES Warranty',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),

              // Google Sign-In
              ElevatedButton.icon(
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        final success = await authProvider.signInWithGoogle();
                        setState(() => _isLoading = false);
                        if (!mounted) return;
                        if (success) {
                          Navigator.pushReplacementNamed(context, '/home');
                        } else if (authProvider.approvalMessage != null) {
                          // message already shown
                        } else {
                          _showMessage('Sign-in failed', isError: true);
                        }
                      },
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Sign in with Google'),
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
                                : FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _isSignUp = true),
                    child: Text('Sign Up',
                        style: TextStyle(
                            fontWeight: _isSignUp
                                ? FontWeight.bold
                                : FontWeight.normal)),
                  ),
                ],
              ),
              if (_isSignUp)
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
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
                          // already showing
                        } else {
                          _showMessage(
                              _isSignUp
                                  ? 'Sign-up failed'
                                  : 'Invalid credentials',
                              isError: true);
                        }
                      },
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_isSignUp ? 'Sign Up' : 'Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
