import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:quiz_competition_flutter/models/TeamModel.dart';

import 'MemberModel.dart';

class OnGoingTeams {
  List<MemberModel> members;
  TeamModel team;
  int teamId;
  OnGoingTeams({
    required this.members,
    required this.team,
    required this.teamId,
  });

  OnGoingTeams copyWith({
    List<MemberModel>? members,
    TeamModel? team,
    int? teamId,
  }) {
    return OnGoingTeams(
      members: members ?? this.members,
      team: team ?? this.team,
      teamId: teamId ?? this.teamId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'members': members.map((x) => x.toMap()).toList()});
    result.addAll({'team': team.toMap()});
    result.addAll({'teamId': teamId});

    return result;
  }

  factory OnGoingTeams.fromMap(Map<String, dynamic> map) {
    return OnGoingTeams(
      members: List<MemberModel>.from(
          map['members']?.map((x) => MemberModel.fromMap(x))),
      team: TeamModel.fromMap(map['team']),
      teamId: map['teamId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OnGoingTeams.fromJson(String source) =>
      OnGoingTeams.fromMap(json.decode(source));

  @override
  String toString() =>
      'OnGoingTeams(members: $members, team: $team, teamId: $teamId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OnGoingTeams &&
        listEquals(other.members, members) &&
        other.team == team &&
        other.teamId == teamId;
  }

  @override
  int get hashCode => members.hashCode ^ team.hashCode ^ teamId.hashCode;
}
