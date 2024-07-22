class UserModel {
  final int id;
  final String email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? phone;
  final String? position;
  final String? company;
  final String? role;
  final String? gender;

  UserModel({
    required this.id,
    required this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.address,
    this.phone,
    this.position,
    this.company,
    this.role,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      address: json['address'],
      phone: json['phone'],
      position: json['position'],
      company: json['company'],
      role: json['role'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'firstname': firstName,
      'lastname': lastName,
      'address': address,
      'phone': phone,
      'position': position,
      'company': company,
      'role': role,
      'gender': gender,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? address,
    String? phone,
    String? position,
    String? company,
    String? role,
    String? gender,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      position: position ?? this.position,
      company: company ?? this.company,
      role: role ?? this.role,
      gender: gender ?? this.gender,
    );
  }
}
