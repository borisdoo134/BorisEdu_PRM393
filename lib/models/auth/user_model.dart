class UserModel {
  final String id;
  final String phone;
  final String username;
  final String firstName;
  final String middleName;
  final String lastName;
  final String avatarUrl;

  UserModel({
    this.id = '',
    this.phone = '',
    this.username = '',
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.avatarUrl = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      middleName: json['middleName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'username': username,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
    };
  }

  String get fullName {
    String name = [firstName, middleName, lastName]
        .where((e) => e.trim().isNotEmpty)
        .join(' ')
        .trim();
    if (name.isEmpty) {
      if (username.isNotEmpty) return username;
      return 'Phụ huynh';
    }
    return name;
  }
}
