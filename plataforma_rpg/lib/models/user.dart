class User {
  int userID;
  String userName;
  String userPassword;

  User({
    required this.userID,
    required this.userName,
    required this.userPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userID'],
      userName: json['userName'],
      userPassword: json['userPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['userName'] = userName;
    data['userPassword'] = userPassword;
    return data;
  }
}
