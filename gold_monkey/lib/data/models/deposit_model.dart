class DepositChannel {
  final String id;      // "BTC_TEST"
  final String name;    // "BITCOIN"
  final String iconUrl; // URL gambar

  DepositChannel({
    required this.id, 
    required this.name, 
    required this.iconUrl
  });

  factory DepositChannel.fromJson(Map<String, dynamic> json) {
    return DepositChannel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      iconUrl: json['icon'] ?? '',
    );
  }
}

// Model untuk Address (Response ketika koin dipilih)
class DepositAddress {
  final String address;
  final String network;
  final String? memo; // Kadang ada koin butuh Memo/Tag

  DepositAddress({
    required this.address, 
    required this.network, 
    this.memo
  });

  factory DepositAddress.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return DepositAddress(
      address: data['address'] ?? '',
      network: data['asset'] ?? '',
      memo: data['memo'],
    );
  }
}