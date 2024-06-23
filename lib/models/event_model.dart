class EventModel {
  final int id;
  final int siteId;
  final int guardId;
  final String description;

  EventModel({
    required this.id,
    required this.siteId,
    required this.guardId,
    required this.description,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      siteId: json['siteId'],
      guardId: json['guardId'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'siteId': siteId,
      'guardId': guardId,
      'description': description,
    };
  }
}
