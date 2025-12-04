import 'package:flutter/material.dart';
import 'package:gold_monkey/data/models/user_model.dart';
import 'package:gold_monkey/data/models/wallet_model.dart';
import 'package:gold_monkey/data/services/auth_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  DashboardData? _dashboardData;
  UserModel? _user;

  DashboardData? get dashboardData => _dashboardData;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Kita panggil 2 API secara paralel (Profile & Wallet) agar cepat
      await Future.wait([
        _fetchUser(),
        _fetchWalletData(),
      ]);
    } catch (e) {
      print("Error loading dashboard: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchUser() async {
    try {
      _user = await _authService.getProfile();
    } catch (e) { /* Ignore error profile, pakai default */ }
  }

  Future<void> _fetchWalletData() async {
    try {
      _dashboardData = await _authService.getDashboard();
    } catch (e) { /* Handle error */ }
  }
}