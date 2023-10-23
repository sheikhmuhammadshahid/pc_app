import 'dart:convert';

import 'Question.dart';

class OnGoingEvent {
  Question? question;
  int eventId;
  String questionForTeam;
  String round;
  String pressedBy;
  int questionNo;
  int totalQuestions;
  OnGoingEvent({
    this.question,
    required this.eventId,
    required this.questionForTeam,
    required this.round,
    required this.pressedBy,
    required this.questionNo,
    required this.totalQuestions,
  });

  OnGoingEvent copyWith({
    Question? question,
    int? eventId,
    String? questionForTeam,
    String? round,
    String? pressedBy,
    int? questionNo,
    int? totalQuestions,
  }) {
    return OnGoingEvent(
      question: question ?? this.question,
      eventId: eventId ?? this.eventId,
      questionForTeam: questionForTeam ?? this.questionForTeam,
      round: round ?? this.round,
      pressedBy: pressedBy ?? this.pressedBy,
      questionNo: questionNo ?? this.questionNo,
      totalQuestions: totalQuestions ?? this.totalQuestions,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (question != null) {
      result.addAll({'question': question!.toMap()});
    }
    result.addAll({'eventId': eventId});
    result.addAll({'questionForTeam': questionForTeam});
    result.addAll({'round': round});
    result.addAll({'pressedBy': pressedBy});
    result.addAll({'questionNo': questionNo});
    result.addAll({'totalQuestions': totalQuestions});

    return result;
  }

  factory OnGoingEvent.fromMap(Map<String, dynamic> map) {
    return OnGoingEvent(
      question:
          map['question'] != null ? Question.fromMap(map['question']) : null,
      eventId: map['eventId'],
      questionForTeam: map['questionForTeam'] ?? '',
      round: map['round'] ?? '',
      pressedBy: map['pressedBy'] ?? '',
      questionNo: map['questionNo'],
      totalQuestions: map['totalQuestions'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OnGoingEvent.fromJson(String source) =>
      OnGoingEvent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OnGoingEvent(question: $question, eventId: $eventId, questionForTeam: $questionForTeam, round: $round, pressedBy: $pressedBy, questionNo: $questionNo, totalQuestions: $totalQuestions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OnGoingEvent &&
        other.question == question &&
        other.eventId == eventId &&
        other.questionForTeam == questionForTeam &&
        other.round == round &&
        other.pressedBy == pressedBy &&
        other.questionNo == questionNo &&
        other.totalQuestions == totalQuestions;
  }

  @override
  int get hashCode {
    return question.hashCode ^
        eventId.hashCode ^
        questionForTeam.hashCode ^
        round.hashCode ^
        pressedBy.hashCode ^
        questionNo.hashCode ^
        totalQuestions.hashCode;
  }
}
