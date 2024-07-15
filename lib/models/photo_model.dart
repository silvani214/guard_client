import 'package:equatable/equatable.dart';

class PhotoModel {
  final String url;
  final DateTime timestamp;
  final Site site;
  final Guard guard;

  PhotoModel(
      {required this.url,
      required this.timestamp,
      required this.site,
      required this.guard});

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      url: json['url'],
      site: Site.fromJson(json['site']),
      guard: Guard.fromJson(json['guard']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'timestamp': timestamp,
    };
  }
}

class Site extends Equatable {
  final int id;
  final String name;
  final String type;
  final String industry;
  final String address;

  Site({
    required this.id,
    required this.name,
    required this.type,
    required this.industry,
    required this.address,
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      industry: json['industry'],
      address: json['address'],
    );
  }

  @override
  List<Object?> get props => [id, name, type, industry, address];
}

class Guard extends Equatable {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String phone;

  Guard({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.phone,
  });

  factory Guard.fromJson(Map<String, dynamic> json) {
    return Guard(
      id: json['id'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      phone: json['phone'],
    );
  }

  @override
  List<Object?> get props => [id, email, firstname, lastname, phone];
}
