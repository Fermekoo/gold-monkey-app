import 'package:flutter/material.dart';
import 'package:gold_monkey/data/models/deposit_model.dart';
import 'package:gold_monkey/data/services/auth_service.dart';

class DepositViewModel extends ChangeNotifier {
  final AuthService _service = AuthService();

  // State
  List<DepositChannel> _channels = [];
  DepositChannel? _selectedChannel; // Koin yang sedang dipilih
  DepositAddress? _depositAddress;  // Data address koin tersebut
  bool _isLoading = false;

  // Getters
  List<DepositChannel> get channels => _channels;
  DepositChannel? get selectedChannel => _selectedChannel;
  DepositAddress? get depositAddress => _depositAddress;
  bool get isLoading => _isLoading;

  // Load awal list koin
  Future<void> loadChannels() async {
    _isLoading = true;
    notifyListeners();
    try {
      _channels = await _service.getDepositChannels();
    } catch (e) {
      print("Error load channels: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Saat user klik salah satu koin
  Future<void> selectChannel(DepositChannel channel) async {
    _selectedChannel = channel;
    _depositAddress = null; // Reset address sebelumnya
    _isLoading = true;
    notifyListeners();

    try {
      _depositAddress = await _service.getDepositAddress(channel.id);
    } catch (e) {
      print("Error generate address: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tombol Back (Kembali ke list)
  void resetSelection() {
    _selectedChannel = null;
    _depositAddress = null;
    notifyListeners();
  }
}