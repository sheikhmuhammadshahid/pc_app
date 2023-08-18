// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class eventss {
  int id;
  String date;
  String type;
  int? Tteams;
  String status;
  eventss({
    required this.id,
    required this.date,
    required this.type,
    this.Tteams,
    required this.status,
  });

  eventss copyWith({
    int? id,
    String? date,
    String? type,
    int? Tteams,
    String? status,
  }) {
    return eventss(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      Tteams: Tteams ?? this.Tteams,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'date': date});
    result.addAll({'type': type});
    if (Tteams != null) {
      result.addAll({'Tteams': Tteams});
    }
    result.addAll({'status': status});

    return result;
  }

  factory eventss.fromMap(Map<String, dynamic> map) {
    return eventss(
      id: int.parse(map['id'] ?? 0),
      date: map['date'] ?? '',
      type: map['type'] ?? '',
      Tteams: int.parse(map['Tteams'] ?? ''),
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory eventss.fromJson(String source) =>
      eventss.fromMap(json.decode(source));

  @override
  String toString() {
    return 'eventss(id: $id, date: $date, type: $type, Tteams: $Tteams, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is eventss &&
        other.id == id &&
        other.date == date &&
        other.type == type &&
        other.Tteams == Tteams &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        type.hashCode ^
        Tteams.hashCode ^
        status.hashCode;
  }
}
