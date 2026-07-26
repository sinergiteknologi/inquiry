import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/app_toast.dart';
import '../providers/connection_provider.dart';
import '../widgets/auth_scaffold.dart';
import 'login_screen.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConnectionProvider>().initialize();
    });
  }

  Future<void> _handleConnect(ConnectionProvider provider) async {
    final result = await provider.connect();
    if (!mounted || result == null) return;

    showAppToast(context, result.message);

    if (result.success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Consumer<ConnectionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return AuthScaffold(
            title: 'Koneksi Server',
            subtitle: 'Masukkan alamat server database',
            isConnected: provider.isConnected,
            leading: TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              label: const Text('Kembali'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: provider.serverController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.dns_outlined),
                    labelText: 'Alamat Server',
                    hintText: '192.168.1.100',
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: provider.isConnecting
                      ? null
                      : () => _handleConnect(provider),
                  child: provider.isConnecting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Hubungkan'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
