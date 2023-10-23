import 'dart:convert';

class EventModel {
  String date;
  String type;
  int id;
  int tTeams;
  String status;
  EventModel({
    required this.date,
    required this.type,
    required this.id,
    required this.tTeams,
    required this.status,
  });

  EventModel copyWith({
    String? date,
    String? type,
    int? id,
    int? tTeams,
    String? status,
  }) {
    return EventModel(
      date: date ?? this.date,
      type: type ?? this.type,
      id: id ?? this.id,
      tTeams: tTeams ?? this.tTeams,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'date': date});
    result.addAll({'type': type});
    result.addAll({'id': id});
    result.addAll({'tTeams': tTeams});
    result.addAll({'status': status});

    return result;
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      date: map['date'] ?? '',
      type: map['type'] ?? '',
      id: int.parse(map['id'] ?? '0'),
      tTeams: int.parse(map['tTeams'] ?? '0'),
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(date: $date, type: $type, id: $id, tTeams: $tTeams, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventModel &&
        other.date == date &&
        other.type == type &&
        other.id == id &&
        other.tTeams == tTeams &&
        other.status == status;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        type.hashCode ^
        id.hashCode ^
        tTeams.hashCode ^
        status.hashCode;
  }
}
