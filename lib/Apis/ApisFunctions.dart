import 'dart:convert';

import 'package:dio/dio.dart';
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
getQuestionss(eventId) async {
  var controller = Get.find<QuestionController>();
  if (controller.ipAddress == "") {
    controller.ipAddress = await Client().getIp();
  }
  List<Question> questions = [];
  try {
    //var contr = Get.find<EventController>();
    var response = await Dio().get('${ip}getQuestionsApi.php?eventId=$eventId');
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
    var response = await Dio().get(url);
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

deleteEvent(eventss e) async {
  var controller = Get.find<QuestionController>();
  if (controller.ipAddress == "") {
    controller.ipAddress = await Client().getIp();
  }
  try {
    var response = await Dio().get(
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

getTeamsDetails() async {
  // var controller = Get.find<QuestionController>();
  // if (controller.ipAddress == "") {
  //   controller.ipAddress = await Client().getIp();
  // }
  var teams = Get.find<TeamsController>();
  try {
    var v = Get.find<QuestionController>();

    var response = await Dio().get(
      '${ip}getEventDetail.php?event_id=${v.eventId}',
    );
    if (response.statusCode == 200) {
      //Get.snackbar('Event', response.data);
      teams.teams.clear();
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

    var response = await Dio().post('${ip}AddEventApi.php',
        data: event.toJson(),
        options: Options(headers: {'Content-type': 'application/json'}));
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

addTeams() async {
  try {} catch (e) {}
}
