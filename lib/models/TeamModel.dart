import 'dart:convert';

class TeamModel {
  String teamName;
  int? id;
  // # status;
  String teamType;
  int scores;
  int totalMembers;
  int buzzerRound;
  int mcqRound;
  int rapidRound;
  int buzzerWrong;
  TeamModel({
    required this.teamName,
    this.id,
    required this.teamType,
    required this.scores,
    required this.totalMembers,
    required this.buzzerRound,
    required this.mcqRound,
    required this.rapidRound,
    required this.buzzerWrong,
  });

  TeamModel copyWith({
    String? teamName,
    int? id,
    String? teamType,
    int? scores,
    int? totalMembers,
    int? buzzerRound,
    int? mcqRound,
    int? rapidRound,
    int? buzzerWrong,
  }) {
    return TeamModel(
      teamName: teamName ?? this.teamName,
      id: id ?? this.id,
      teamType: teamType ?? this.teamType,
      scores: scores ?? this.scores,
      totalMembers: totalMembers ?? this.totalMembers,
      buzzerRound: buzzerRound ?? this.buzzerRound,
      mcqRound: mcqRound ?? this.mcqRound,
      rapidRound: rapidRound ?? this.rapidRound,
      buzzerWrong: buzzerWrong ?? this.buzzerWrong,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'teamName': teamName});
    if (id != null) {
      result.addAll({'id': id});
    }
    result.addAll({'teamType': teamType});
    result.addAll({'scores': scores});
    result.addAll({'totalMembers': totalMembers});
    result.addAll({'buzzerRound': buzzerRound});
    result.addAll({'mcqRound': mcqRound});
    result.addAll({'rapidRound': rapidRound});
    result.addAll({'buzzerWrong': buzzerWrong});

    return result;
  }

  factory TeamModel.fromMap(Map<String, dynamic> map) {
    return TeamModel(
      teamName: map['teamName'] ?? '',
      id: map['id']?.toInt(),
      teamType: map['teamType'] ?? '',
      scores: map['scores']?.toInt() ?? 0,
      totalMembers: map['totalMembers']?.toInt() ?? 0,
      buzzerRound: map['buzzerRound']?.toInt() ?? 0,
      mcqRound: map['mcqRound']?.toInt() ?? 0,
      rapidRound: map['rapidRound']?.toInt() ?? 0,
      buzzerWrong: map['buzzerWrong']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TeamModel.fromJson(String source) =>
      TeamModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TeamModel(teamName: $teamName, id: $id, teamType: $teamType, scores: $scores, totalMembers: $totalMembers, buzzerRound: $buzzerRound, mcqRound: $mcqRound, rapidRound: $rapidRound, buzzerWrong: $buzzerWrong)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TeamModel &&
        other.teamName == teamName &&
        other.id == id &&
        other.teamType == teamType &&
        other.scores == scores &&
        other.totalMembers == totalMembers &&
        other.buzzerRound == buzzerRound &&
        other.mcqRound == mcqRound &&
        other.rapidRound == rapidRound &&
        other.buzzerWrong == buzzerWrong;
  }

  @override
  int get hashCode {
    return teamName.hashCode ^
        id.hashCode ^
        teamType.hashCode ^
        scores.hashCode ^
        totalMembers.hashCode ^
        buzzerRound.hashCode ^
        mcqRound.hashCode ^
        rapidRound.hashCode ^
        buzzerWrong.hashCode;
  }
}
