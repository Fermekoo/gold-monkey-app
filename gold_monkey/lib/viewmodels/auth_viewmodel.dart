import 'package:flutter/material.dart';
import 'package:gold_monkey/data/models/login_model.dart';
import 'package:gold_monkey/data/models/register_model.dart';
import 'package:gold_monkey/data/services/auth_service.dart';

class AuthViewmodel extends ChangeNotifier{
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        throw "all field are required";
      }
      
      final request = RegisterRequest(username: username, email: email, password: password);
      final success = await _authService.register(request);
      _isLoading = false;
      notifyListeners();
      return success;

    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (email.isEmpty || password.isEmpty) {
        throw "all field are required";
      }

      final request = LoginRequest(email: email, password: password);
      final success = await _authService.login(request);
      _isLoading = false;
      notifyListeners();
      return success;

    } catch (e) {
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return false;
    }
  }
}