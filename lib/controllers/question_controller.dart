import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_competition_flutter/Client/Clients.dart';
import 'package:quiz_competition_flutter/models/MyMessage.dart';

import '../models/OnGoingEventModel.dart';
import '../models/Question.dart';
import 'EventsController.dart';
import 'TeamsController.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io' show Platform;
// We use get package for our state management

class QuestionController extends GetxController
    with GetTickerProviderStateMixin {
  // Lets animated our progress bar
  RxInt gval = 0.obs;
  AnimationController? animationController;
  Animation? _animation;
  final AudioPlayer _assetsAudioPlayer = AudioPlayer();
  String? round;

  // so that we can access our animation outside
  Animation get animation => _animation!;
  String ipAddress = "";
  late PageController _pageController;
  PageController get pageController => _pageController;
  // static int ongoingEventId = 7;
  Rx<Color> progressColor = Colors.green.obs;
  late RxList questions = [].obs;
  OnGoingEvent? ongoinQuestion;
  RxBool isOptionsDisabled = false.obs;
  final RxBool _isAnswered = false.obs;
  RxBool get isAnswered => _isAnswered;
  String pressedBy = '-1';

  late String _correctAns;
  String get correctAns => _correctAns;

  late String _selectedAns;
  String get selectedAns => _selectedAns;
  List<Question> allQuestions = [];
  late int eventId = 0;

  // RxInt get questionNumber => _questionNumber;

  final int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  // called immediately after the widget is allocated memory

  @override
  void onInit() {
    // Our animation duration is 60 s
    // so our plan is to fill the progress bar within 60s
    animationController = AnimationController(
        duration: Duration(
            seconds: round != 'rapid'
                ? round == 'buzzer'
                    ? 7
                    : 60
                : 120),
        vsync: this)
      ..addListener(() {
        if (animationController!.value == 10 && Platform.isWindows) {
          playTimerSound();
        }
        if (animationController!.value == 10) {
          progressColor.value = Colors.red;
        } else if (animationController!.duration!.inSeconds / 2 ==
            animationController!.value) {
          progressColor.value = Colors.amberAccent[700]!;
        }
        try {
          if (ongoinQuestion != null && animationController!.value == 1) {
            if (ongoinQuestion!.round == 'buzzer') {
              Get.find<ClientGetController>().sendMessage(
                  MyMessage(todo: 'RapidAnswer', value: 'wrong').toJson());
            }
          }
        } catch (e) {}
      });
    _animation = Tween<double>(begin: 1, end: 0).animate(animationController!)
      ..addListener(() {
        // update like setState

        update();
      });
    // start our animation
    // Once 60s is completed go to the next qn
    // if (animationController != null) {
    //   animationController!.reverse().whenComplete(nextQuestion);
    // }
    _pageController = PageController();
    super.onInit();
  }

  // // called just before the Controller is deleted from memory
  @override
  void onClose() {
    super.onClose();
    if (animationController != null) {
      animationController!.dispose();
    }
    _pageController.dispose();
  }

  void checkAns(Question question, String selectedIndex) {
    // because once user press any option then it will run
    _isAnswered.value = true;
    _correctAns = question.answer.trim();
    _selectedAns = selectedIndex.trim();
    try {
      if (animationController != null) {
        animationController!.stop();
      }
    } catch (e) {}

    update();
    if (teamController.ongoingTeams.any((element) =>
        element.team.teamName.toLowerCase() ==
            eventController.teamName.value.toLowerCase() ||
        element.team.teamName.toLowerCase() == pressedBy.toLowerCase())) {
      round = question.type.toLowerCase();
      if (round != 'buzzer') {
        eventController.team = teamController.ongoingTeams.indexWhere(
            (element) =>
                element.team.teamName.toLowerCase() ==
                eventController.teamName.value.toLowerCase());
      } else {
        eventController.team = teamController.ongoingTeams.indexWhere(
            (element) =>
                element.team.teamName.toLowerCase() == pressedBy.toLowerCase());
      }
      print('============ team index is ${eventController.team}');
      if (_correctAns == _selectedAns) {
        playCorrectSong();

        if (round == 'rapid') {
          teamController.ongoingTeams[eventController.team].team.rapidRound++;
          teamController.ongoingTeams[eventController.team].team.scores++;
        } else if (round == 'buzzer') {
          teamController.ongoingTeams[eventController.team].team.buzzerRound++;
          teamController.ongoingTeams[eventController.team].team.scores++;
        } else if (round == 'mcq') {
          teamController.ongoingTeams[eventController.team].team.mcqRound++;
          teamController.ongoingTeams[eventController.team].team.scores++;
        }
      } else if (round == 'buzzer') {
        playWrongSong();
        // teamController.ongoingTeams[eventController.team].team.scores -= 2;
        teamController.ongoingTeams[eventController.team].team.buzzerWrong++;
      } else {
        playWrongSong();
      }
    }

    // It will stop the counter

    // Once user select an ans after 3s it will go to the next qn
    // Future.delayed(const Duration(seconds: 3), () {
    //   nextQuestion();
    // });
  }

  playWrongSong() async {
    //_assetsAudioPlayer.open(Audio("assets/icons/Songs/Wrong.wav"));
    await _assetsAudioPlayer.play(AssetSource('icons/Songs/wrong.wav'));
  }

  playCorrectSong() async {
    await _assetsAudioPlayer.play(
      AssetSource('icons/Songs/correct.wav'),
      //volume: 100
    );
    // _assetsAudioPlayer.open(Audio("assets/icons/Songs/correct.wav"));
    // _assetsAudioPlayer.play();
  }

  playBuzzer() async {
    await _assetsAudioPlayer.play(
      AssetSource('icons/Songs/buzzerPressed.wav'),
      //volume: 100
    );
  }

  playBuzzerPressed() async {
    await _assetsAudioPlayer.play(
      AssetSource('icons/Songs/buzzerPressed.wav'),
      //volume: 100
    );
    // _assetsAudioPlayer.open(Audio("assets/icons/Songs/BuzzerPressed.wav"));
    // _assetsAudioPlayer.play();
  }

  playTimerSound() async {
    await _assetsAudioPlayer.play(AssetSource("icons/Songs/buzzerPressed.wav"));
  }

  var eventController = Get.put(EventController());
  var teamController = Get.put(TeamsController());
}
