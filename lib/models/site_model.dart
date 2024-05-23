import 'location_model.dart';
import 'hit_point_model.dart';

class SiteModel {
  final int id;
  final String name;
  final String description;
  final LocationModel location;
  late List<HitPointModel>? hitPointList = [];
  late String? address = "";

  SiteModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.location,
      this.address,
      this.hitPointList});

  factory SiteModel.fromJson(Map<String, dynamic> json) {
    var hitPointListFromJson = json['hitPointList'] as List<dynamic>?;
    List<HitPointModel>? hitPoints = hitPointListFromJson != null
        ? hitPointListFromJson
            .map((item) => HitPointModel.fromJson(item))
            .toList()
        : [];

    return SiteModel(
        id: json['id'],
        name: json['name'],
        description: '',
        address: json['address'],
        location: LocationModel(
          latitude: json['x'],
          longitude: json['y'],
        ),
        hitPointList: hitPoints);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'location': location.toJson(),
      'hitPointList': hitPointList?.map((e) => e.toJson()).toList(),
    };
  }

  SiteModel copyWith({
    int? id,
    String? name,
    String? description,
    String? address,
    LocationModel? location,
    List<HitPointModel>? hitPointList,
  }) {
    return SiteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      location: location ?? this.location,
      hitPointList: hitPointList ?? this.hitPointList,
    );
  }

  @override
  String toString() {
    return 'SiteModel(id: $id, name: $name, description: $description, address: $address, location: $location)';
  }
}
