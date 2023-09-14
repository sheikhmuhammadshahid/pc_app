import 'dart:convert';

import 'package:dio/dio.dart' as d;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pc_app/controllers/EventsController.dart';
import 'package:pc_app/controllers/TeamsController.dart';
import 'package:pc_app/controllers/question_controller.dart';
import 'package:pc_app/models/Event.dart';
import 'package:pc_app/models/QuestionModel.dart';
import 'package:pc_app/models/TeamModel.dart';

import '../Client/Clients.dart';

String ip = 'https://compitionapp.cozyreach.com/';
String imageAddress = 'https://compitionapp.cozyreach.com/images/';

d.Options options = d.Options(headers: {'Content-Type': 'application/json'});
getQuestionss(eventId) async {
  // var controller = Get.find<QuestionController>();
  // if (controller.ipAddress == "") {
  //   controller.ipAddress = await Client().getIp();
  // }
  List<Question> questions = [];
  try {
    //var contr = Get.find<EventController>();

    var response =
        await d.Dio().get('${ip}getQuestionsApi.php?eventId=$eventId');
    if (response.statusCode == 200) {
      for (var element in response.data) {
        questions.add(Question.fromMap(element));
      }
      //return v.m
    }
  } catch (e) {
    print(e);
  }
  return questions;
}

getEventsLists() async {
  QuestionController controller;

  controller = Get.find<QuestionController>();

  List<eventss> events = [];
  try {
    var url = '${ip}getEventsApi.php';
    var response = await d.Dio().get(url);
    if (response.statusCode == 200) {
      for (var element in response.data) {
        events.add(eventss.fromMap(element));
      }
      //return v.m
    }
  } catch (e) {
    print(e);
  }

  return events;
}

saveQuestions({required List<Question> questions}) async {
  try {
    for (var element in questions) {
      try {
        await d.Dio().post('${ip}addQuestionApi.php',
            data: element.toJson(), options: options);
      } catch (e) {
        EasyLoading.showToast(e.toString());
      }
    }
    EasyLoading.dismiss();
    EasyLoading.showToast('Questions Saved Successfully!');
  } catch (e) {
    EasyLoading.dismiss();
  }
}

deleteEvent(eventss e) async {
  var controller = Get.find<QuestionController>();
  if (controller.ipAddress == "") {
    controller.ipAddress = await Client().getIp();
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

getTeamsDetails(int eventId) async {
  // var controller = Get.find<QuestionController>();
  // if (controller.ipAddress == "") {
  //   controller.ipAddress = await Client().getIp();
  // }
  var teams = Get.find<TeamsController>();
  try {
    var v = Get.find<QuestionController>();

    var response = await d.Dio().get(
      '${ip}getEventDetail.php?event_id=$eventId',
    );
    teams.teams.clear();
    if (response.statusCode == 200) {
      //Get.snackbar('Event', response.data);

      for (var element in response.data) {
        //return v.m
        teams.teams.add(team.fromMap(element));
      }
    }
  } catch (e) {
    print(e);
  }
  return teams.teams;
}

saveEvent(eventss event) async {
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

addTeams({required List<team> members, required int eventId}) async {
  try {
    var res =
        await d.Dio().get('${ip}ClearEventDetailApi.php?event_id=$eventId');
    for (var element in members) {
      await EasyLoading.dismiss();
      EasyLoading.show(
          status: 'uploading data of team ${element.teamName}',
          dismissOnTap: false);
      var response = await d.Dio().post('${ip}AddTeamApi.php',
          options: options,
          data: {
            "teamName": element.teamName,
            "TeamType": element.TeamType,
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
