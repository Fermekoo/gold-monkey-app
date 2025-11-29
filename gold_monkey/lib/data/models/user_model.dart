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
    return UserModel(
      username: json["username"] ?? "Uknown user",
      email: json["emaill"] ?? "-",
      avaURL: json["avatar"] ?? "https://i.pravatar.cc/300"
    );
  }
}