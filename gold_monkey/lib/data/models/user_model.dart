class UserModel {
  final String username;
  final String email;
  final String avaURL;

  UserModel({
    required this.username,
    required this.email,
    this.avaURL = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['data'] ?? json;
    return UserModel(
      username: userData["username"] ?? "Uknown user",
      email: userData["email"] ?? "-",
      avaURL: userData["avatar"] ?? "https://i.pravatar.cc/300"
    );
  }
}