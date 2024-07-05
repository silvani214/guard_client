class EventModel {
  final int id;
  final int siteId;
  final int guardId;
  final String description;
  final DateTime timestamp;

  EventModel(
      {required this.id,
      required this.siteId,
      required this.guardId,
      required this.description,
      required this.timestamp});

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      siteId: json['siteId'],
      guardId: json['guardId'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'siteId': siteId,
      'guardId': guardId,
      'description': description,
      'timestamp': timestamp.toString(),
    };
  }
}
