import 'package:flutter/material.dart';
import 'package:gold_monkey/core/constants/app_colors.dart';
import 'package:gold_monkey/core/utils/app_formatters.dart';
import 'package:gold_monkey/viewmodels/dashboard_viewmodel.dart';
import 'package:gold_monkey/viewmodels/page_viewmodel.dart';
import 'package:gold_monkey/views/widgets/glass_container.dart';
import 'package:gold_monkey/views/widgets/profile_ava.dart';
import 'package:provider/provider.dart';


class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardViewModel>(context, listen: false).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: vm.isLoading
              ? Center(child: CircularProgressIndicator(color: AppColors.primary))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      
                      // --- 1. HEADER (Greeting & Profile) ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Good Morning,", style: TextStyle(color: AppColors.textSecondary)),
                              Text(
                                vm.user?.username ?? "User",
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          // Avatar Clickable
                          GestureDetector(
                            onTap: () {
                              Provider.of<PageViewModel>(context, listen: false).changePage(2);
                            },
                            child: ProfileVatar(url: vm.user?.avaURL ?? "https://i.pravatar.cc/300"),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 30),

                      // --- 2. TOTAL BALANCE CARD ---
                      GlassContainer(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Balance", style: TextStyle(color: AppColors.textSecondary)),
                            SizedBox(height: 8),
                            Text(
                              vm.dashboardData != null 
                                  ? AppFormatters.crypto(vm.dashboardData!.totalBalanceUsd)
                                  : "\$0.00",
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 32, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 24),
                            // Action Buttons Dummy
                            Row(
                              children: [
                                _buildActionButton(Icons.arrow_upward, "Deposit", () {
                                  Provider.of<PageViewModel>(context, listen: false).changePage(1);
                                }),
                                SizedBox(width: 16),
                                _buildActionButton(Icons.arrow_downward, "Withdraw", () {
                                  Provider.of<PageViewModel>(context, listen: false).changePage(1);
                                }),
                              ],
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 30),

                      // --- 3. WALLET LIST TITLE ---
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Wallets", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 16),

                      // --- 4. WALLET LIST ITEMS ---
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: vm.loadDashboard,
                          child: ListView.builder(
                            itemCount: vm.dashboardData?.wallets.length ?? 0,
                            itemBuilder: (context, index) {
                              final wallet = vm.dashboardData!.wallets[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                // Kita gunakan GlassContainer versi tipis atau container biasa
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white10,
                                    child: Image.network(wallet.iconUrl), // Placeholder icon
                                    // Idealnya gunakan Image.network(wallet.iconUrl)
                                  ),
                                  title: Text(wallet.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  subtitle: Text("${AppFormatters.crypto(wallet.balance)} ${wallet.code}", style: TextStyle(color: AppColors.textSecondary)),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(AppFormatters.currency(wallet.value), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      Text(
                                        "${AppFormatters.currency(wallet.price)}", // Harga satuan
                                        style: TextStyle(color: Colors.greenAccent, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback? onTap) {
  return Expanded(
    child: GestureDetector( // Ganti Container langsung dengan GestureDetector
      onTap: onTap, // Pasang aksi tap di sini
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}
}