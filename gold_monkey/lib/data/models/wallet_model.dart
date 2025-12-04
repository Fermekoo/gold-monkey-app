class WalletItem {
  final String code;    
  final String name;    
  final double balance; // UBAH KE DOUBLE agar bisa diformat currency
  final double price;   
  final double value;
  final String iconUrl; // Tambahkan ini karena response backend mengirim 'icon'   

  WalletItem({
    required this.code,
    required this.name,
    required this.balance,
    required this.price,
    required this.value,
    this.iconUrl = '',
  });

  factory WalletItem.fromJson(Map<String, dynamic> json) {
    // Helper function aman
    // Menerima input String ("100") atau Number (100) dan mengubahnya jadi double
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return WalletItem(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      
      // PARSING KE DOUBLE
      balance: parseDouble(json['balance']),
      price: parseDouble(json['price']),
      value: parseDouble(json['value']),
      
      // Ambil icon url
      iconUrl: json['icon'] ?? '',
    );
  }
}

class DashboardData {
  final double totalBalanceUsd;
  final List<WalletItem> wallets;

  DashboardData({required this.totalBalanceUsd, required this.wallets});

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    // 1. Cek Wrapper 'data'
    // Backend Anda mengirim: { "data": { ... } }
    final root = json['data'] ?? json;
    
    var list = root['wallets'] as List? ?? [];
    List<WalletItem> walletsList = list.map((i) => WalletItem.fromJson(i)).toList();

    return DashboardData(
      // 2. PARSING TOTAL BALANCE (Fix Error Disini)
      // Mengubah String "295000" menjadi double 295000.0
      totalBalanceUsd: double.tryParse(root['total_balance'].toString()) ?? 0.0,
      
      wallets: walletsList,
    );
  }
}