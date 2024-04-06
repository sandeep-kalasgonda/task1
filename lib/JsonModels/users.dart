
class Users {
  final int? userid;
  final String username;
  final String password;
  final String email;
  final String phone;

  Users({
     this.userid,
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    userid: json["userid"],
    username: json["username"],
    password: json["password"],
    email: json["email"],
    phone: json["phone"],
  );

  Map<String, dynamic> toMap() => {
    "userid": userid,
    "username": username,
    "password": password,
    "email": email,
    "phone": phone,
  };
}
