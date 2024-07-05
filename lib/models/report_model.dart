import 'package:equatable/equatable.dart';

class ReportModel extends Equatable {
  final int id;
  final Guard guard;
  final Site site;
  final String nature;
  final String description;
  final DateTime timestamp;
  final List<Photo> photoList;

  ReportModel({
    required this.id,
    required this.guard,
    required this.site,
    required this.nature,
    required this.description,
    required this.timestamp,
    required this.photoList,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['report']['id'],
      guard: Guard.fromJson(json['report']['guard']),
      site: Site.fromJson(json['report']['site']),
      nature: json['report']['nature'],
      description: json['report']['description'],
      timestamp: DateTime.parse(json['report']['timestamp']),
      photoList: (json['photoList'] as List)
          .map((photo) => Photo.fromJson(photo))
          .toList(),
    );
  }

  @override
  List<Object?> get props =>
      [id, guard, site, nature, description, timestamp, photoList];
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

class Photo extends Equatable {
  final int id;
  final String url;

  Photo({
    required this.id,
    required this.url,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      url: json['url'],
    );
  }

  @override
  List<Object?> get props => [id, url];
}
