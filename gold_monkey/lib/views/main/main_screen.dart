import 'package:flutter/material.dart';
import 'package:gold_monkey/core/constants/app_colors.dart';
import 'package:gold_monkey/viewmodels/page_viewmodel.dart';
import 'package:gold_monkey/views/dashboard_screen.dart';
import 'package:gold_monkey/views/deposit_screen.dart';
import 'package:gold_monkey/views/profile_screen.dart';
import 'package:provider/provider.dart';
class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  // 1. Hapus 'const' di sini agar tidak error jika Screen di dalamnya bukan const constructor
  final List<Widget> _pages = [
    DashboardScreen(),
    DepositScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Dengarkan perubahan halaman dari ViewModel
    final pageVM = Provider.of<PageViewModel>(context);

    return Scaffold(
      // Gunakan index dari VM
      body: IndexedStack(
        index: pageVM.currentIndex,
        children: _pages,
      ),

      // FAB DEPOSIT (TENGAH)
      floatingActionButton: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.primary, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          // Panggil VM untuk pindah ke index 1 (Deposit)
          onPressed: () => pageVM.changePage(1),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.arrow_upward_rounded, size: 32, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // BOTTOM NAV
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1C1C2E),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- Menu Kiri (Home) ---
              _buildNavItem(
                icon: Icons.grid_view_rounded,
                label: "Home",
                isSelected: pageVM.currentIndex == 0,
                onTap: () => pageVM.changePage(0),
              ),

              const SizedBox(width: 40), // Spacer untuk FAB

              // --- Menu Kanan (Profile) ---
              _buildNavItem(
                icon: Icons.person_outline_rounded,
                label: "Profile",
                isSelected: pageVM.currentIndex == 2,
                onTap: () => pageVM.changePage(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. Implementasi Lengkap method _buildNavItem (Perbaikan Utama)
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}