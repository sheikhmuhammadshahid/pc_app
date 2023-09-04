import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:pc_app/models/memberModel.dart';

class team extends GetxController {
  int id;
  String teamName;
  String TeamType;
  int? scores;
  int? totalmembers;
  int? buzzerRound;
  int? mcqRound;
  List<member> members = [];
  int? rapidRound;
  RxString status = 'Pending'.obs;
  Socket? socket;
  int? buzzerWrong;
  team({
    required this.id,
    required this.teamName,
    required this.TeamType,
    this.scores,
    this.totalmembers,
    this.buzzerRound,
    this.mcqRound,
    required this.members,
    this.rapidRound,
    this.buzzerWrong,
  });

  team copyWith({
    int? id,
    String? teamName,
    String? TeamType,
    int? scores,
    int? totalmembers,
    int? buzzerRound,
    int? mcqRound,
    List<member>? members,
    int? rapidRound,
    int? buzzerWrong,
  }) {
    return team(
      id: id ?? this.id,
      teamName: teamName ?? this.teamName,
      TeamType: TeamType ?? this.TeamType,
      scores: scores ?? this.scores,
      totalmembers: totalmembers ?? this.totalmembers,
      buzzerRound: buzzerRound ?? this.buzzerRound,
      mcqRound: mcqRound ?? this.mcqRound,
      members: members ?? this.members,
      rapidRound: rapidRound ?? this.rapidRound,
      buzzerWrong: buzzerWrong ?? this.buzzerWrong,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'teamName': teamName});
    result.addAll({'TeamType': TeamType});
    if (scores != null) {
      result.addAll({'scores': scores});
    }
    if (totalmembers != null) {
      result.addAll({'totalmembers': totalmembers});
    }
    if (buzzerRound != null) {
      result.addAll({'buzzerRound': buzzerRound});
    }
    if (mcqRound != null) {
      result.addAll({'mcqRound': mcqRound});
    }
    result.addAll({'members': members.map((x) => x.toMap()).toList()});
    if (rapidRound != null) {
      result.addAll({'rapidRound': rapidRound});
    }
    if (buzzerWrong != null) {
      result.addAll({'buzzerWrong': buzzerWrong});
    }

    return result;
  }

  factory team.fromMap(Map<String, dynamic> map) {
    return team(
      id: map['id']?.toInt() ?? 0,
      teamName: map['teamName'] ?? '',
      TeamType: map['TeamType'] ?? '',
      scores: map['scores'] != null && map['scores'] != ''
          ? map['scores']?.toInt()
          : 0,
      totalmembers: map['totalmembers']?.toInt(),
      buzzerRound: map['buzzerRound']?.toInt(),
      mcqRound: map['mcqRound']?.toInt(),
      members: List<member>.from(map['members']?.map((x) => member.fromMap(x))),
      rapidRound: map['rapidRound']?.toInt(),
      buzzerWrong: map['buzzerWrong']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory team.fromJson(String source) => team.fromMap(json.decode(source));

  @override
  String toString() {
    return 'team(id: $id, teamName: $teamName, TeamType: $TeamType, scores: $scores, totalmembers: $totalmembers, buzzerRound: $buzzerRound, mcqRound: $mcqRound, members: $members, rapidRound: $rapidRound, buzzerWrong: $buzzerWrong)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is team &&
        other.id == id &&
        other.teamName == teamName &&
        other.TeamType == TeamType &&
        other.scores == scores &&
        other.totalmembers == totalmembers &&
        other.buzzerRound == buzzerRound &&
        other.mcqRound == mcqRound &&
        listEquals(other.members, members) &&
        other.rapidRound == rapidRound &&
        other.buzzerWrong == buzzerWrong;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        teamName.hashCode ^
        TeamType.hashCode ^
        scores.hashCode ^
        totalmembers.hashCode ^
        buzzerRound.hashCode ^
        mcqRound.hashCode ^
        members.hashCode ^
        rapidRound.hashCode ^
        buzzerWrong.hashCode;
  }
}
