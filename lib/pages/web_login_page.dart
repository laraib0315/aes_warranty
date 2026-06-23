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
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Side - Branding
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo.png',
                              height: 120,
                              width: 120,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.verified,
                                size: 110,
                                color: Color(0xFFE7712D),
                              ),
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'AES Warranty',
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE7712D),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Powering Trust, Delivering Quality',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                'Digital Warranty Management System\nfor Electrical Products',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),

                      // Right Side - Login Form
                      Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 8,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Sign in to manage warranties',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 36),

                                // Google Sign-In – Proper button
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: OutlinedButton(
                                    onPressed: authProvider.isLoading
                                        ? null
                                        : () async {
                                            setState(() => _isLoading = true);
                                            final success = await authProvider
                                                .signInWithGoogle();
                                            setState(() => _isLoading = false);
                                            if (!mounted) return;
                                            if (success) {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                '/web_home',
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Google Sign-In failed. Check internet.'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      side: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/google_logo.png',
                                          height: 28,
                                          width: 28,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(
                                            Icons.g_mobiledata,
                                            size: 28,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        const Text(
                                          'Continue with Google',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Row(
                                  children: [
                                    Expanded(child: Divider()),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text('OR',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14)),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Toggle
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          setState(() => _isSignUp = false),
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
                                      onPressed: () =>
                                          setState(() => _isSignUp = true),
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
                                        labelStyle:
                                            const TextStyle(fontSize: 15),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        prefixIcon:
                                            const Icon(Icons.person_outline),
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
                                    prefixIcon:
                                        const Icon(Icons.email_outlined),
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

                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: authProvider.isLoading
                                        ? null
                                        : () async {
                                            setState(() => _isLoading = true);
                                            bool success;
                                            if (_isSignUp) {
                                              success = await authProvider
                                                  .signUpWithEmail(
                                                _emailController.text.trim(),
                                                _passwordController.text.trim(),
                                                _usernameController.text.trim(),
                                              );
                                            } else {
                                              success = await authProvider
                                                  .signInWithEmail(
                                                _emailController.text.trim(),
                                                _passwordController.text.trim(),
                                              );
                                            }
                                            setState(() => _isLoading = false);
                                            if (!mounted) return;
                                            if (success) {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                '/web_home',
                                              );
                                            } else if (authProvider
                                                    .approvalMessage ==
                                                null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _isSignUp
                                                        ? 'Sign-up failed. Email may exist or weak password.'
                                                        : 'Invalid email or password.',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE7712D),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white)
                                        : Text(
                                            _isSignUp ? 'Sign Up' : 'Sign In',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : // Mobile version
                Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                          const SizedBox(height: 16),
                          const Text(
                            'AES Warranty',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE7712D),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Powering Trust, Delivering Quality',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          OutlinedButton(
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
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
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
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    setState(() => _isSignUp = false),
                                child: const Text('Sign In',
                                    style: TextStyle(fontSize: 16)),
                              ),
                              const SizedBox(width: 20),
                              TextButton(
                                onPressed: () =>
                                    setState(() => _isSignUp = true),
                                child: const Text('Sign Up',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ],
                          ),
                          if (_isSignUp)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                    labelText: 'Username'),
                              ),
                            ),
                          TextField(
                            controller: _emailController,
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _passwordController,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE7712D),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Sign In',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
