enum Action { VISITOR, REPORT, Trespasser, Arrived, WATER_LEAK }

const Map<String, String> fontAwesomeIcons = {
  'fire': 'https://fontawesome.com/icons/fire?f=classic&s=solid',
  'flood': 'https://fontawesome.com/icons/house-flood-water?f=classic&s=solid',
  'blackout':
      'https://fontawesome.com/icons/plug-circle-minus?f=classic&s=solid',
  'water leak': 'https://fontawesome.com/icons/droplet?f=classic&s=solid',
  'visitor':
      'https://fontawesome.com/icons/person-circle-question?f=classic&s=solid',
  'trespasser':
      'https://fontawesome.com/icons/person-through-window?f=sharp&s=solid',
  'fire alarm': 'https://fontawesome.com/icons/sensor-fire?f=classic&s=solid',
  'squatter': 'https://fontawesome.com/icons/tents?f=classic&s=solid',
  'drug paraphernalia':
      'https://fontawesome.com/icons/syringe?f=classic&s=solid',
  'vagrant':
      'https://fontawesome.com/icons/square-person-confined?f=classic&s=solid',
  'police': 'https://fontawesome.com/icons/car-on?f=classic&s=solid',
  'door not secure':
      'https://fontawesome.com/icons/door-open?f=classic&s=solid',
  'deceased':
      'https://fontawesome.com/icons/skull-crossbones?f=classic&s=solid',
  'ems': 'https://fontawesome.com/icons/truck-medical?f=classic&s=solid',
  'suspicious vehicle':
      'https://fontawesome.com/icons/car-tunnel?f=classic&s=solid',
  'dangerous chemical':
      'https://fontawesome.com/icons/biohazard?f=classic&s=solid',
};

class EventModel {
  final int id;
  final int siteId;
  final int guardId;
  final String action;
  final String description;
  final DateTime timestamp;

  EventModel(
      {required this.id,
      required this.siteId,
      required this.guardId,
      required this.action,
      required this.description,
      required this.timestamp});

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      siteId: json['siteId'],
      guardId: json['guardId'],
      action: json['action'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'siteId': siteId,
      'guardId': guardId,
      'action': action,
      'description': description,
      'timestamp': timestamp.toString(),
    };
  }
}
