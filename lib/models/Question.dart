import 'dart:convert';

class Question {
  String ques;
  int id;
  String opt1;
  String opt2;
  String opt3;
  String opt4;
  String answer;
  String type;
  int eventId;
  Question({
    required this.ques,
    required this.id,
    required this.opt1,
    required this.opt2,
    required this.opt3,
    required this.opt4,
    required this.answer,
    required this.type,
    required this.eventId,
  });

  Question copyWith({
    String? ques,
    int? id,
    String? opt1,
    String? opt2,
    String? opt3,
    String? opt4,
    String? answer,
    String? type,
    int? eventId,
  }) {
    return Question(
      ques: ques ?? this.ques,
      id: id ?? this.id,
      opt1: opt1 ?? this.opt1,
      opt2: opt2 ?? this.opt2,
      opt3: opt3 ?? this.opt3,
      opt4: opt4 ?? this.opt4,
      answer: answer ?? this.answer,
      type: type ?? this.type,
      eventId: eventId ?? this.eventId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'ques': ques});
    result.addAll({'id': id});
    result.addAll({'opt1': opt1});
    result.addAll({'opt2': opt2});
    result.addAll({'opt3': opt3});
    result.addAll({'opt4': opt4});
    result.addAll({'answer': answer});
    result.addAll({'type': type});
    result.addAll({'eventId': eventId});

    return result;
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      ques: map['ques'] ?? '',
      id: int.parse(map['id']),
      opt1: map['opt1'] ?? '',
      opt2: map['opt2'] ?? '',
      opt3: map['opt3'] ?? '',
      opt4: map['opt4'] ?? '',
      answer: map['answer'] ?? '',
      type: map['type'] ?? '',
      eventId: int.parse(map['eventId'] ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Question(ques: $ques, id: $id, opt1: $opt1, opt2: $opt2, opt3: $opt3, opt4: $opt4, answer: $answer, type: $type, eventId: $eventId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Question &&
        other.ques == ques &&
        other.id == id &&
        other.opt1 == opt1 &&
        other.opt2 == opt2 &&
        other.opt3 == opt3 &&
        other.opt4 == opt4 &&
        other.answer == answer &&
        other.type == type &&
        other.eventId == eventId;
  }

  @override
  int get hashCode {
    return ques.hashCode ^
        id.hashCode ^
        opt1.hashCode ^
        opt2.hashCode ^
        opt3.hashCode ^
        opt4.hashCode ^
        answer.hashCode ^
        type.hashCode ^
        eventId.hashCode;
  }
}
