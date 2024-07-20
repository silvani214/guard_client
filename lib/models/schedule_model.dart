class ScheduleModel {
  final String text;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final int guardId;
  final int hours;
  final double frequency;
  final String announces;

  ScheduleModel({
    required this.text,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.guardId,
    required this.hours,
    required this.frequency,
    required this.announces,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      text: json['text'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      guardId: json['guardId'],
      hours: json['hours'],
      frequency: json['frequency'],
      announces: json['announces'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'guardId': guardId,
      'hours': hours,
      'frequency': frequency,
      'announces': announces,
    };
  }
}
