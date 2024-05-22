import 'location_model.dart';

class SiteModel {
  final int id;
  final String name;
  final String description;
  final LocationModel location;

  SiteModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) {
    return SiteModel(
        id: json['id'],
        name: json['name'],
        description: '',
        location: LocationModel(
          latitude: json['x'],
          longitude: json['y'],
        ));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location.toJson(),
    };
  }

  SiteModel copyWith({
    int? id,
    String? name,
    String? description,
    LocationModel? location,
  }) {
    return SiteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
    );
  }

  @override
  String toString() {
    return 'SiteModel(id: $id, name: $name, description: $description, location: $location)';
  }
}
