import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/app_toast.dart';
import '../providers/login_provider.dart';
import '../widgets/auth_scaffold.dart';
import 'connection_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginProvider>().initialize();
    });
  }

  void _handleLogin(LoginProvider provider) {
    final result = provider.validateLogin();

    switch (result) {
      case LoginValidation.invalidCredentials:
        showAppToast(context, 'Password Atau Username Salah');
      case LoginValidation.notConnected:
        showAppToast(context, 'Lampu Indicator Berwarna Merah');
      case LoginValidation.success:
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Consumer<LoginProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return AuthScaffold(
            title: 'Login',
            subtitle: 'Masuk untuk inquiry harga produk',
            isConnected: provider.isConnected,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: provider.usernameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: provider.passwordController,
                  obscureText: provider.obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: provider.togglePasswordVisibility,
                      icon: Icon(
                        provider.obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _handleLogin(provider),
                  child: const Text('Masuk'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Nb: Jika lingkaran berwarna merah',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const ConnectionScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        transitionDuration: const Duration(milliseconds: 400),
                      ),
                    );
                  },
                  child: const Text('Klik Disini'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
