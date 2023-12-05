class Login {
  String accessToken;
  String refreshToken;
  String name;
  String phone;
  bool admin;

  Login({
    required this.accessToken,
    required this.refreshToken,
    required this.name,
    required this.phone,
    required this.admin,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      name: json['name'],
      phone: json['phone'],
      admin: json['admin'],
    );
  }
}
