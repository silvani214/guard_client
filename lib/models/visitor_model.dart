import 'location_model.dart';
import 'hit_point_model.dart';
import 'package:equatable/equatable.dart';

class VisitorModel {
  final int id;
  final Site site;
  final String fullname;
  final String? company;
  final String? licenseplate;
  final String? url;
  final DateTime? timestamp;

  VisitorModel(
      {required this.id,
      required this.site,
      required this.fullname,
      required this.company,
      required this.licenseplate,
      this.url,
      this.timestamp});

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      id: json['id'],
      site: Site.fromJson(json['site']),
      fullname: json['fullname'],
      company: json['company'],
      licenseplate: json['licenseplate'],
      url: json['url'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'company': company,
      'licenseplate': licenseplate,
      'url': url,
      'timestamp': timestamp.toString(),
    };
  }

  VisitorModel copyWith({
    int? id,
    Site? site,
    String? fullname,
    String? company,
    String? licenseplate,
    String? url,
    DateTime? timestamp,
  }) {
    return VisitorModel(
      id: id ?? this.id,
      site: site ?? this.site,
      fullname: fullname ?? this.fullname,
      company: company ?? this.company,
      licenseplate: licenseplate ?? this.licenseplate,
      url: url ?? this.url,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'VisitorModel(id: $id, fullname: $fullname, company: $company, licenseplate: $licenseplate, url: $url)';
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
