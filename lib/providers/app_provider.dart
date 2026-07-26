import 'package:flutter/material.dart';

import '../core/services/api_service.dart';
import '../core/services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  bool? _isConnected;
  bool _isLoading = true;

  bool? get isConnected => _isConnected;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    final savedUrl = await StorageService.getServerUrl();
    if (savedUrl == null || savedUrl.isEmpty) {
      _isConnected = false;
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final result = await ApiService.connect(savedUrl);
      _isConnected = result.success;
      if (!result.success) {
        await StorageService.clearConnection();
      }
    } catch (_) {
      _isConnected = false;
      await StorageService.clearConnection();
    }

    _isLoading = false;
    notifyListeners();
  }

  void setConnected(bool value) {
    _isConnected = value;
    notifyListeners();
  }
}
