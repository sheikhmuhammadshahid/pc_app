import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_competition_flutter/Client/Clients.dart';
import 'package:quiz_competition_flutter/constant.dart';
import 'package:quiz_competition_flutter/controllers/EventsController.dart';
import 'package:quiz_competition_flutter/controllers/TeamsController.dart';
import 'package:quiz_competition_flutter/controllers/question_controller.dart';

import '../models/OnGoingEventModel.dart';
import '../models/OnGoingTeamsModel.dart';
import '../models/Question.dart';
import 'ApiClient.dart';

class ClientProvider extends ChangeNotifier {
  List<String> messages = [];
  bool isAnswered = false;
  AnimationController? animationController;
  Animation? _animation;
  Animation get animation => _animation!;
  int eventId = -1;
  String? round;
  String pressedBy = '-1';
  bool adminConnected = true;
  bool admin1Connected = false;
  String correctAnswer = '';
  String selectedAnswer = '';
  List<String> connecteds = [];
  List<Question> questions = [];
  int questionNo = 0;
  List<Question> allQuestions = [];
  bool isHidden = false;
  changePressedBy({required String name}) {
    pressedBy = name;
    Get.find<QuestionController>().pressedBy = name;
    notifyListeners();
  }

  changeHiddenState({bool toHide = false}) {
    try {
      isHidden = toHide;
      notifyListeners();
    } catch (e) {}
  }

  bool isResultShowing = false;
  changeResultScreenState({bool toHide = false}) {
    try {
      isResultShowing = toHide;
      notifyListeners();
    } catch (e) {}
  }

  getQuestions() async {
    if (allQuestions.isEmpty) {
      allQuestions = await getQuestionss(eventId: eventId);
      // ignore: use_build_context_synchronously
      await getTeamDetail();
    }

    if (round == 'rapid') {
      Get.find<QuestionController>().animationController!.duration =
          const Duration(seconds: 120);
    } else if (round == 'buzzer') {
      Get.find<QuestionController>().animationController!.duration =
          const Duration(seconds: 5);
    } else {
      Get.find<QuestionController>().animationController!.duration =
          const Duration(seconds: 60);
    }
    questionNo = 0;
    questions = [];
    // notifyListeners();
    questions = allQuestions
        .where((element) =>
            element.type.toLowerCase().contains(round.toString().toLowerCase()))
        .toList();
    print('---------round------');
    print('questions: ${questions.length} ');
    try {
      sendMessage();
    } catch (e) {}
    notifyListeners();
  }

  updatedQUestions({required List<Question> question}) async {
    questions = question;
    questionNo = 0;

    await sendMessage();
    print('========questions updated==========');
    notifyListeners();
  }

  PageController pageController = PageController();
  // PageController get pageController => _pageController;
  nextQuestion() async {
    try {
      if (questionNo < questions.length - 1) {
        questionNo++;
        await updateTheQnNum();
        await sendMessage();
        await pageController.nextPage(
            duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
        notifyListeners();
      }
    } catch (e) {}
  }

  previousQuestion() async {
    try {
      if (questionNo > 0) {
        questionNo--;
        updateTheQnNum();
        await sendMessage();
        await pageController.previousPage(
            duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
        notifyListeners();
      }
    } catch (e) {}
  }

  sendMessage() async {
    try {
      Get.find<ClientGetController>().sendMessage(OnGoingEvent(
              eventId: eventId,
              pressedBy: '-1',
              round: round ?? "",
              questionForTeam: Get.find<EventController>().teamName.value,
              question: questions.isNotEmpty ? questions[questionNo] : null,
              questionNo: questionNo,
              totalQuestions: questions.length)
          .toJson());
    } catch (e) {}
  }

  int isConnected = 0;
  String? questionType;

// getting called at ad questions to change event, question type
  changeQuestionType({required String? type}) {
    questionType = type;
    notifyListeners();
  }

  OnGoingEvent? ongoinQuestion;

  updateOnGoingQUestion(OnGoingEvent onGoingEvent) {
    ongoinQuestion = onGoingEvent;
    Get.find<QuestionController>().ongoinQuestion = ongoinQuestion;
    Get.find<QuestionController>().round = ongoinQuestion!.round;

    pressedBy = '-1';
    Get.find<QuestionController>().pressedBy = '-1';
    Get.find<EventController>().teamName.value = onGoingEvent.questionForTeam;
    Get.find<QuestionController>().isAnswered.value = false;

    notifyListeners();
  }

  Socket? socket;
  addMessage(String message) {
    messages.add(message);
    notifyListeners();
  }

  addSocket(Socket socket) {
    this.socket = socket;
    notifyListeners();
  }

  removeSocket() {
    try {
      socket!.destroy();
    } catch (e) {}
    socket = null;
    notifyListeners();
  }

  connected(int connected) {
    isConnected = connected;
    notifyListeners();
  }

  addConnectedTeam({required String teamName, bool toAdd = true}) {
    if (teamName.toLowerCase() != 'admin' &&
        teamName.toLowerCase() != 'admin1') {
      if (toAdd) {
        if (!connecteds.contains(teamName)) {
          connectedTeams++;
          connecteds.add(teamName);
        }
      } else {
        if (connecteds.remove(teamName)) {
          connectedTeams--;
        }
      }
      if (connectedTeams == ongoingTeams.length &&
          admin1Connected &&
          adminConnected) {
        showQuestinos = true;
        sendMessage();
      } else {
        showQuestinos = false;
      }
      notifyListeners();
    } else {
      if (teamName.toLowerCase() == 'admin') {
        adminConnected = toAdd;
      } else {
        admin1Connected = toAdd;
      }
      if (!admin1Connected || !adminConnected) {
        showQuestinos = false;
      }
      notifyListeners();
    }
  }

  List<OnGoingTeams> ongoingTeams = [];
  bool showQuestinos = false;
  int connectedTeams = 0;
  getTeamDetail() async {
    try {
      ongoingTeams = await getTeamsDetails(eventId: eventId);
      Get.find<TeamsController>().ongoingTeams = ongoingTeams;
      Get.find<EventController>().teamName.value =
          ongoingTeams[0].team.teamName;
      connectedTeams = 0;
      notifyListeners();
    } catch (e) {}
  }

  EventController eventController = Get.find<EventController>();
  TeamsController teamsController = Get.find<TeamsController>();
  updateTheQnNum() async {
    print('checikg0===========');
    if (round == 'mcq') {
      if (eventController.onGoingEvent!.tTeams - 1 > eventController.team) {
        eventController.team++;
      } else {
        eventController.team = 0;
      }
      eventController.teamName.value = teamsController
          .ongoingTeams[eventController.team].team.teamName
          .toString();
    } else if (round == 'rapid') {
      print('checikg===========$questionNo');
      if (questionNo < questions.length / 2) {
        eventController.team = 0;
        eventController.teamName.value =
            ongoingTeams[0].team.teamName.toString();
      }
      if (questionNo == (questions.length / 2)) {
        print('checikg3===========$questionNo');
        eventController.team = 1;
        // Get.find<QuestionController>().animationController!.stop();
        await Get.defaultDialog(
            confirm: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Ok')),
            content: const Text('Press ok to continue for next team'));
        // Get.find<QuestionController>().animationController!.reset();
        // Get.find<QuestionController>().animationController!.repeat();
        eventController.teamName.value =
            ongoingTeams[1].team.teamName.toString();
      }
    }
  }
}
