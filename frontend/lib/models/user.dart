class User {
  String name;
  String email;
  String password;
  String? id;
  String? token;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.id,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
      };
}
