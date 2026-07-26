import 'package:flutter/material.dart';

import '../core/services/api_service.dart';
import '../core/services/storage_service.dart';

class ConnectionProvider extends ChangeNotifier {
  final serverController = TextEditingController();

  bool _isConnected = false;
  bool _isLoading = true;
  bool _isConnecting = false;

  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  bool get isConnecting => _isConnecting;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _isConnected = await StorageService.isConnected();
    final savedUrl = await StorageService.getServerUrl();
    if (savedUrl != null && savedUrl != 'null') {
      serverController.text = savedUrl;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<ConnectResult?> connect() async {
    final serverUrl = serverController.text.trim();
    if (serverUrl.isEmpty) {
      return ConnectResult(success: false, message: 'Harap diisi');
    }

    _isConnecting = true;
    notifyListeners();

    try {
      final result = await ApiService.connect(serverUrl);
      if (result.success) {
        await StorageService.saveConnection(
          serverUrl: serverUrl,
          isConnected: true,
        );
        _isConnected = true;
      } else {
        await StorageService.clearConnection();
        _isConnected = false;
      }
      return result;
    } catch (_) {
      await StorageService.clearConnection();
      _isConnected = false;
      return ConnectResult(success: false, message: 'Gagal');
    } finally {
      _isConnecting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    serverController.dispose();
    super.dispose();
  }
}
