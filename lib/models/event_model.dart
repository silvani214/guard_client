class EventModel {
  final int id;
  final int siteId;
  final int guardId;
  final String description;
  final String title;
  final String time;

  EventModel({
    required this.id,
    required this.siteId,
    required this.guardId,
    required this.description,
    required this.title,
    required this.time,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      siteId: json['siteId'],
      guardId: json['guardId'],
      description: json['description'],
      title: json['title'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'siteId': siteId,
      'guardId': guardId,
      'description': description,
      'title': title,
      'time': time,
    };
  }
}
