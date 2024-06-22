import 'location_model.dart';

class HitPointModel {
  final int id;
  final String name;
  final int siteId;

  HitPointModel({
    required this.id,
    required this.name,
    required this.siteId,
  });

  factory HitPointModel.fromJson(Map<String, dynamic> json) {
    return HitPointModel(
      id: json['id'],
      name: json['name'],
      siteId: json['siteId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'siteId': siteId};
  }

  HitPointModel copyWith({
    int? id,
    String? name,
    int? siteId,
    LocationModel? location,
  }) {
    return HitPointModel(
      id: id ?? this.id,
      name: name ?? this.name,
      siteId: siteId ?? this.siteId,
    );
  }

  @override
  String toString() {
    return 'HitPointModel(id: $id, name: $name, siteId: $siteId)';
  }
}
