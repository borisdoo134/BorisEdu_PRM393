class StudentModel {
  final String id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String className;
  final String schoolName;
  final String academicYear;
  final String status;
  final String avatarUrl;
  final String dateOfBirth;
  final String address;
  final String gender;
  final String phone;
  final String fatherName;
  final String motherName;

  StudentModel({
    this.id = '',
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.className = '',
    this.schoolName = '',
    this.academicYear = '',
    this.status = '',
    this.avatarUrl = '',
    this.dateOfBirth = '',
    this.address = '',
    this.gender = '',
    this.phone = '',
    this.fatherName = '',
    this.motherName = '',
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    String cName = '';
    String sName = '';
    String aYear = '';

    if (json['schoolClass'] != null) {
      cName = json['schoolClass']['className']?.toString() ?? '';
      sName = json['schoolClass']['schoolName']?.toString() ?? '';
      aYear = json['schoolClass']['academicYear']?.toString() ?? '';
    }

    return StudentModel(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      middleName: json['middleName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      className: cName,
      schoolName: sName,
      academicYear: aYear,
      status: json['status']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      fatherName: json['fatherName']?.toString() ?? '',
      motherName: json['motherName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'className': className,
      'schoolName': schoolName,
      'academicYear': academicYear,
      'status': status,
      'avatarUrl': avatarUrl,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'gender': gender,
      'phone': phone,
      'fatherName': fatherName,
      'motherName': motherName,
    };
  }

  String get fullName {
    String name = [firstName, middleName, lastName]
        .where((e) => e.trim().isNotEmpty)
        .join(' ')
        .trim();
    return name.isEmpty ? "Chưa có tên" : name;
  }

  String get displayStatus {
    return status == "LEARNING" ? "Đang học" : status;
  }
  
  String get displayGender {
    return gender == 'MALE' ? 'Nam' : (gender == 'FEMALE' ? 'Nữ' : 'Khác');
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
