import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart' as d;
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:quiz_competition_flutter/models/OnGoingTeamsModel.dart';

// import 'package:quiz_competition_client/quiz_competition_client.dart';

import '../Client/Clients.dart';
import '../controllers/EventsController.dart';
import '../controllers/TeamsController.dart';
import '../controllers/question_controller.dart';
import '../models/EventModel.dart';
import '../models/MemberModel.dart';
import '../models/Question.dart';
import '../models/TeamModel.dart';

String ip = 'https://compitionapp.cozyreach.com/';
String imageAddress = 'https://compitionapp.cozyreach.com/images/';

d.Options options = d.Options(headers: {'Content-Type': 'application/json'});
getQuestionss({required int eventId}) async {
  List<Question> questions = [];
  try {
    var response =
        await d.Dio().get('${ip}getQuestionsApi.php?eventId=$eventId');
    print(response.data);
    if (response.statusCode == 200) {
      for (var element in response.data) {
        questions.add(Question.fromMap(element));
      }
      //return v.m
    }
  } catch (e) {
    EasyLoading.show(status: e.toString(), dismissOnTap: true);
    print(e);
  }
  return questions;
}

getEventsLists() async {
  EventController controller;

  controller = Get.find<EventController>();

  List<EventModel> events = [];
  try {
    var url = '${ip}getEventsApi.php';
    var response = await d.Dio().get(url);
    if (response.statusCode == 200) {
      for (var element in response.data) {
        events.add(EventModel.fromMap(element));
      }
      //return v.m
    }
  } catch (e) {
    print(e);
  }
  controller.eventssList.value = events;
  controller.filteredEvents.value = events;
  return events;
}

deleteTeam({required int teamId}) async {
  try {
    EasyLoading.show(status: 'Deleting', dismissOnTap: false);
    await Dio().get('${ip}deleteTeamApi.php?teamId=$teamId');
    EasyLoading.dismiss();
  } catch (e) {}
}

deleteMemberApi({required int memberId}) async {
  try {
    await Dio().get('${ip}deleteMemberApi.php?memberId=$memberId');
  } catch (e) {}
}

saveQuestions({required List<Question> questions, required int eventId}) async {
  try {
    List<Map<String, dynamic>> data = [];
    for (var element in questions) {
      data.add(element.toMap());
    }
    try {
      await d.Dio().post('${ip}addQuestionApi.php?eventId=$eventId',
          data: jsonEncode(data), options: options);
    } catch (e) {
      EasyLoading.showToast(e.toString());
    }
    // or (var element in questions) {}
  } catch (e) {
    EasyLoading.dismiss();
  }
}

deleteEvent({required EventModel e}) async {
  var controller = Get.find<QuestionController>();
  if (controller.ipAddress == "") {
    controller.ipAddress = await ClientGetController().getIp();
  }
  try {
    var response = await d.Dio().get(
      '${ip}deleteEvent.php?event_id=${e.id}',
    );
    if (response.statusCode == 200) {
      EasyLoading.showToast('Event ${response.data}');
      //return v.m
    }
  } catch (e) {
    print(e);
  }
}

Future<List<OnGoingTeams>> getTeamsDetails({required int eventId}) async {
  var teams = Get.find<TeamsController>();
  try {
    var response = await d.Dio().get(
      '${ip}getEventDetail.php?event_id=$eventId',
    );
    teams.ongoingTeams.clear();
    if (response.statusCode == 200) {
      for (var element in response.data) {
        teams.ongoingTeams.add(OnGoingTeams(
          members: List<MemberModel>.from(
              element['members']?.map((x) => MemberModel.fromMap(x))),
          team: TeamModel(
              id: element['id'],
              teamName: element['teamName'],
              teamType: element['TeamType'],
              scores: 0,
              totalMembers: 0,
              buzzerRound: 0,
              mcqRound: 0,
              rapidRound: 0,
              buzzerWrong: 0),
          teamId: element['id'],
        ));
      }
    }
  } catch (e) {
    print(e);
  }
  return teams.ongoingTeams;
}

saveEvent({required EventModel event}) async {
  try {
    EventController eventController = Get.find<EventController>();

    var response = await d.Dio()
        .post('${ip}AddEventApi.php', data: event.toJson(), options: options);
    if (response.statusCode == 201) {
      Get.back();
      EasyLoading.showToast('Added successfully', dismissOnTap: true);
      var data = jsonDecode(response.data);
      event.id = data['lastInsertedId'];
      eventController.eventssList.add(event);

      print('s');
    } else {
      Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 2),
        message: 'Failed to add',
      ));
    }
  } catch (e) {
    print(e);
  }
}

addTeams({required List<OnGoingTeams> members, required int eventId}) async {
  try {
    var res =
        await d.Dio().get('${ip}ClearEventDetailApi.php?eventId=$eventId');
    for (var element in members) {
      await EasyLoading.dismiss();
      EasyLoading.show(
          status: 'uploading data of team ${element.team.teamName}',
          dismissOnTap: false);
      var response =
          await d.Dio().post('${ip}AddTeamApi.php', options: options, data: {
        "teamName": element.team.teamName,
        "TeamType": element.team.teamType,
        "eventId": eventId
      });

      if (response.statusCode == 201) {
        int teamid = int.parse(response.data);
        for (var element1 in element.members) {
          d.FormData formData = d.FormData.fromMap({
            "name": element1.name,
            'img': element1.image,
            "image": element1.img == ''
                ? null
                : await d.MultipartFile.fromFile(element1.img),
            "phoneNo": element1.phoneNo,
            "aridNo": element1.aridNo,
            "semester": element1.semester,
            "teamId": teamid
          });
          response = await d.Dio()
              .post('${ip}addMembersApi.php', options: options, data: formData);
        }
      }
    }

    EasyLoading.dismiss();
    EasyLoading.showToast('Added successfully!');
  } catch (e) {
    EasyLoading.dismiss();
    EasyLoading.showToast('there was some issue while uploading data!');
  }
}
