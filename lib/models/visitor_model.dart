import 'location_model.dart';
import 'hit_point_model.dart';

class VisitorModel {
  final int id;
  final String fullname;
  final String? company;
  final String? licenseplate;
  final String? url;
  final DateTime? timestamp;

  VisitorModel(
      {required this.id,
      required this.fullname,
      required this.company,
      required this.licenseplate,
      this.url,
      this.timestamp});

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      id: json['id'],
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
    String? fullname,
    String? company,
    String? licenseplate,
    String? url,
    DateTime? timestamp,
  }) {
    return VisitorModel(
      id: id ?? this.id,
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
