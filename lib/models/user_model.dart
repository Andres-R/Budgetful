class UserModel {
  late int id;
  late String username;
  late String email;
  late String password;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    username = map["username"];
    email = map["email"];
    password = map["password"];
  }
}
