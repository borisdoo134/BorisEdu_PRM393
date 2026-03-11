class UserModel {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String firstName;
  final String middleName;
  final String lastName;
  final String avatarUrl;

  // CÁC TRƯỜNG DÀNH RIÊNG CHO HỌC SINH
  final String dateOfBirth;
  final String address;
  final String gender;
  final String status;
  final String fatherName;
  final String motherName;

  final Map<String, dynamic>? schoolClass;
  final List<UserModel> children;

  UserModel({
    this.id = '',
    this.username = '',
    this.email = '',
    this.phone = '',
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.avatarUrl = '',
    this.dateOfBirth = '',
    this.address = '',
    this.gender = '',
    this.status = '',
    this.fatherName = '',
    this.motherName = '',
    this.schoolClass,
    this.children = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      middleName: json['middleName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      fatherName: json['fatherName']?.toString() ?? '',
      motherName: json['motherName']?.toString() ?? '',
      schoolClass: json['schoolClass'] as Map<String, dynamic>?,
      children: (json['children'] as List? ?? [])
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'gender': gender,
      'status': status,
      'fatherName': fatherName,
      'motherName': motherName,
      'schoolClass': schoolClass,
      'children': children.map((e) => e.toJson()).toList(),
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

  // Tương tự StudentModel cũ
  String get className => schoolClass?['className']?.toString() ?? '';
  String get schoolName => schoolClass?['schoolName']?.toString() ?? '';
  String get academicYear => schoolClass?['academicYear']?.toString() ?? '';

  String get displayStatus => status == "LEARNING" ? "Đang học" : status;

  String get displayGender {
    if (gender == 'MALE') return 'Nam';
    if (gender == 'FEMALE') return 'Nữ';
    if (gender.isNotEmpty) return 'Khác';
    return '';
  }

  String get formattedDateOfBirth {
    if (dateOfBirth.isEmpty) return 'Không có';
    try {
      final DateTime parsedDate = DateTime.parse(dateOfBirth);
      return "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}";
    } catch (_) {
      return dateOfBirth;
    }
  }
}
