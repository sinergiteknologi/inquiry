import 'dart:async';

import 'package:flutter/material.dart';

import '../core/services/api_service.dart';
import '../core/services/storage_service.dart';
import '../models/product_model.dart';

class HomeProvider extends ChangeNotifier {
  final scanController = TextEditingController();
  final focusNode = FocusNode();

  String? _serverUrl;
  List<ProductModel> _products = [];
  String? _formattedCode;
  String _messageLine1 = '';
  String _messageLine2 = '';
  String _messageLine3 = '';
  bool _isFetching = false;
  Timer? _debounceTimer;
  Timer? _messageTimer;
  Timer? _refreshTimer;

  List<ProductModel> get products => _products;
  String? get formattedCode => _formattedCode;
  String get messageLine1 => _messageLine1;
  String get messageLine2 => _messageLine2;
  String get messageLine3 => _messageLine3;
  bool get isFetching => _isFetching;
  bool get hasMessages =>
      _messageLine1.isNotEmpty ||
      _messageLine2.isNotEmpty ||
      _messageLine3.isNotEmpty;

  Future<void> initialize() async {
    _serverUrl = await StorageService.getServerUrl();
    focusNode.requestFocus();

    _refreshTimer = Timer.periodic(
      const Duration(minutes: 20),
      (_) => _keepAlive(),
    );

    notifyListeners();
  }

  void onScanChanged(String value) {
    _debounceTimer?.cancel();
    if (value.trim().isEmpty) return;

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      fetchProduct(value.trim());
    });
  }

  Future<void> fetchProduct(String barcode) async {
    if (_serverUrl == null || _serverUrl!.isEmpty || _isFetching) return;

    _isFetching = true;
    _clearMessages();
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      final products = await ApiService.fetchProduct(
        serverUrl: _serverUrl!,
        barcode: barcode,
      );

      if (products.isEmpty) {
        _showNotFoundMessage();
      } else {
        _products = products;
        _formattedCode = products.first.formattedCode();
      }

      scanController.clear();
      focusNode.requestFocus();
    } on ApiException catch (e) {
      _showServerError(e.message);
    } catch (_) {
      _showServerError('Terjadi kesalahan koneksi');
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  void _showNotFoundMessage() {
    _products = [];
    _formattedCode = null;
    _messageLine1 = 'DATA TIDAK DITEMUKAN';
    _messageLine2 = 'HARAP HUBUNGI STAFF KAMI';
    _messageLine3 = 'SILAHKAN SCAN PRODUK BERIKUTNYA';

    _messageTimer?.cancel();
    _messageTimer = Timer(const Duration(seconds: 3), () {
      _clearMessages();
      notifyListeners();
    });
  }

  void _showServerError(String message) {
    _products = [];
    _formattedCode = null;
    _messageLine1 = message;
    _messageLine2 = '';
    _messageLine3 = '';
  }

  void _clearMessages() {
    _messageLine1 = '';
    _messageLine2 = '';
    _messageLine3 = '';
  }

  Future<void> _keepAlive() async {
    if (_serverUrl == null) return;
    try {
      await ApiService.connect(_serverUrl!);
    } catch (_) {}
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _messageTimer?.cancel();
    _refreshTimer?.cancel();
    scanController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
