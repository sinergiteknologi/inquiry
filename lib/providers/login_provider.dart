import 'package:flutter/material.dart';

import '../core/services/api_service.dart';
import '../core/services/storage_service.dart';

class LoginProvider extends ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isConnected = false;
  bool _isLoading = true;
  bool _obscurePassword = true;

  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;

  static const defaultUsername = 'admin';
  static const defaultPassword = 'admin';

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _isConnected = await StorageService.isConnected();
    _isLoading = false;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  LoginValidation validateLogin() {
    if (usernameController.text != defaultUsername ||
        passwordController.text != defaultPassword) {
      return LoginValidation.invalidCredentials;
    }
    if (!_isConnected) {
      return LoginValidation.notConnected;
    }
    return LoginValidation.success;
  }

  Future<void> refreshConnectionStatus() async {
    final savedUrl = await StorageService.getServerUrl();
    if (savedUrl == null || savedUrl.isEmpty) {
      _isConnected = false;
      notifyListeners();
      return;
    }

    try {
      final result = await ApiService.connect(savedUrl);
      _isConnected = result.success;
    } catch (_) {
      _isConnected = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

enum LoginValidation {
  success,
  invalidCredentials,
  notConnected,
}
