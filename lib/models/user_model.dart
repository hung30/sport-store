class UserModel {
  String id;
  String username;
  String password;
  UserModel({required this.id, required this.username, required this.password});
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'], username: json['username'], password: json['password']);
  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'password': password};
  }
}

List<UserModel> userList = [
  UserModel(id: '1', username: "hung30", password: "123456"),
  UserModel(id: "2", username: "sonle", password: "123456"),
];
