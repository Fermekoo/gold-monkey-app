import 'package:flutter/material.dart';

class PageViewModel extends ChangeNotifier {
  int _currentIndex = 0; // 0: Home, 1: Deposit, 2: Profile

  int get currentIndex => _currentIndex;

  void changePage(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}