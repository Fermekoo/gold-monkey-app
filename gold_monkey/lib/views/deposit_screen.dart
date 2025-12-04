import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk Copy Clipboard
import 'package:gold_monkey/core/constants/app_colors.dart';
import 'package:gold_monkey/viewmodels/deposit_viewmodel.dart';
import 'package:gold_monkey/views/widgets/glass_container.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DepositScreen extends StatefulWidget {
  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  @override
  void initState() {
    super.initState();
    // Load data saat pertama buka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<DepositViewModel>(context, listen: false);
      vm.resetSelection(); // Pastikan mulai dari awal
      vm.loadChannels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DepositViewModel>(context);

    return Scaffold(
      extendBodyBehindAppBar: true, // Agar gradient tembus ke atas
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          vm.selectedChannel == null ? "Deposit Crypto" : vm.selectedChannel!.name,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        // Logic Tombol Back di AppBar
        leading: vm.selectedChannel != null 
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => vm.resetSelection(), // Kembali ke list koin
              )
            : null, // Hilangkan tombol back jika di list utama (karena ini Tab Menu)
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: vm.isLoading
              ? Center(child: CircularProgressIndicator(color: AppColors.primary))
              : vm.selectedChannel == null
                  ? _buildChannelList(vm)
                  : _buildAddressDetail(vm),
        ),
      ),
    );
  }

  // --- VIEW 1: LIST COIN (BTC, ETH, dll) ---
  Widget _buildChannelList(DepositViewModel vm) {
    if (vm.channels.isEmpty) {
      return Center(child: Text("No channels available", style: TextStyle(color: Colors.white54)));
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      itemCount: vm.channels.length,
      itemBuilder: (context, index) {
        final channel = vm.channels[index];
        return GestureDetector(
          onTap: () => vm.selectChannel(channel),
          child: Container(
            margin: EdgeInsets.only(bottom: 16),
            child: GlassContainer(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  // Icon Image dari URL
                  Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      channel.iconUrl,
                      errorBuilder: (ctx, err, stack) => Icon(Icons.broken_image, size: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        channel.id, // e.g. BTC_TEST
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        channel.name, // e.g. BITCOIN
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.chevron_right, color: Colors.white54),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- VIEW 2: QR CODE & ADDRESS ---
  Widget _buildAddressDetail(DepositViewModel vm) {
    final address = vm.depositAddress;
    if (address == null) return Container();

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            "Scan QR Code",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          SizedBox(height: 20),

          // QR Code Card
          GlassContainer(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QrImageView(
                    data: address.address,
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  address.network,
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          SizedBox(height: 30),

          // Address Info
          Align(
            alignment: Alignment.centerLeft, 
            child: Text("Wallet Address", style: TextStyle(color: AppColors.textSecondary))
          ),
          SizedBox(height: 8),

          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: address.address));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Address copied to clipboard!"), backgroundColor: Colors.green),
              );
            },
            child: GlassContainer(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              customFillColor: Colors.black.withOpacity(0.3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      address.address,
                      style: TextStyle(
                        color: Colors.white, 
                        fontFamily: 'Courier', // Font gaya mesin ketik agar jelas
                        fontSize: 14
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.copy, color: AppColors.primary),
                ],
              ),
            ),
          ),

          // Warning Box
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Only send ${vm.selectedChannel?.name} (${vm.selectedChannel?.id}) to this address. Sending any other coins may result in permanent loss.",
                    style: TextStyle(color: Colors.amberAccent, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}