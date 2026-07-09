class UserModel {
  final String id;
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final String avatar;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    this.fullName = '',
    this.phone = '',
    this.avatar = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'fullName': fullName,
      'phone': phone,
      'avatar': avatar,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      avatar: map['avatar'] ?? '',
    );
  }
}
