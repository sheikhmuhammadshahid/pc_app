import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:quiz_competition_flutter/controllers/EventsController.dart';
import 'package:quiz_competition_flutter/controllers/TeamsController.dart';
import 'package:quiz_competition_flutter/controllers/question_controller.dart';
import 'package:quiz_competition_flutter/models/OnGoingEventModel.dart';

import 'package:quiz_competition_flutter/screens/quiz/quiz_screen.dart';
import 'package:quiz_competition_flutter/screens/serverside/result_Screen.dart';

import '../GetConnectToServerDialogue.dart';
import '../models/MyMessage.dart';
import '../screens/serverside/dashboard.dart';
import '../screens/serverside/widgets/que_screen.dart';
import 'ClientDetails.dart';

class ClientGetController extends GetxController {
  Rx<TextEditingController> ipController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  late ClientProvider clientProvider;
  RxInt isConnected = 0.obs;
  late MyMessage myMessage;
  bool socket_connected = false;
  connect(ip, port) async {
    try {
      Socket socket = await Socket.connect(ip, 1234);
      clientProvider.addSocket(socket);
      socket_connected = true;

      return socket;
    } catch (e) {
      print(e);
      EasyLoading.show(
          status: 'Server is not started yet.', dismissOnTap: true);
      socket_connected = false;
      return null;
    }
  }

  Future<void> connectToServer(ClientProvider clientProvidr) async {
    try {
      // Set the server's IP address and port number
      String ipAddress = ipController.value.text.trim();
      const int port = 1234;
      clientProvider = clientProvidr;
      if (await connect(ipAddress, port) != null) {
        // Get.back();
        print('Connected to the server.');
        handleMessages();
        sendMessage(MyMessage(
                todo: 'connected',
                value: nameController.value.text.trim().toLowerCase())
            .toJson());

        // if (nameController.value.text.toLowerCase() == 'admin') {
        //   Get.to(const DashBoardScreen());
        // } else {}
        // Get.to(const QuizScreen());

        // Start listening for messages from the server
      }
      EasyLoading.dismiss();
      // Get.back();
    } catch (e) {
      // Get.back();
      EasyLoading.show(
          status: 'Server is not started yet.', dismissOnTap: true);

      print('Error: $e');
    }
  }

  int isMyMessage(jsonData) {
    try {
      if (jsonData.containsKey('todo') && jsonData.containsKey('value')) {
        return 1;
      } else if (jsonData.containsKey('round') &&
          jsonData.containsKey('totalQuestions')) {
        return 2;
      }
    } catch (e) {
      print(e);
      // Handle any potential exceptions when decoding JSON.
    }

    return 0;
  }

  checkMessage(data) async {
    try {
      String message = String.fromCharCodes(data).trim();
      print('Received from server: $message');
      int res = isMyMessage(jsonDecode(message));
      print(res);
      if (res == 1) {
        Map<String, dynamic> map = jsonDecode(message);
        if (map['todo'] == "Teamsconnected") {
          List<String> teams = map['value'].toString().split(',').toList();
          for (var element in teams) {
            clientProvider.addConnectedTeam(teamName: element);
          }
        } else if (map['todo'] == 'NextTeam') {
          if (map['value'] == 'next') {
            clientProvider.questionNo =
                (clientProvider.questions.length ~/ 2) - 1;
            clientProvider.nextQuestion(fromClient: true);
          } else {
            clientProvider.nextQuestion();
          }
        } else if (map['todo'] == 'result') {
          if (nameController.value.text.trim() == 'admin1' &&
              map['value'] == "true") {
            print(
                'type ==========${clientProvider.ongoinQuestion!.question!.type}');
            Get.to(ResultScreen(
                round: clientProvider.ongoinQuestion!.question!.type
                    .toLowerCase()));
          } else if (nameController.value.text.trim() == 'admin1') {
            Get.back();
          }
        } else if (map['todo'] == 'hide') {
          clientProvider.changeHiddenState(
              toHide: bool.tryParse(map['value']) ?? false);
        } else if (map['todo'] == 'RapidAnswer') {
          TeamsController teamsController = Get.find<TeamsController>();
          EventController eventController = Get.find<EventController>();
          if (teamsController.ongoingTeams.any((element) =>
              element.team.teamName.toLowerCase() ==
              eventController.teamName.value.toLowerCase())) {
            if (clientProvider.ongoinQuestion!.round.toLowerCase() !=
                'buzzer') {
              eventController.team = teamsController.ongoingTeams.indexWhere(
                  (element) =>
                      element.team.teamName.toLowerCase() ==
                      eventController.teamName.value.toLowerCase());
            } else {
              eventController.team = teamsController.ongoingTeams.indexWhere(
                  (element) =>
                      element.team.teamName.toLowerCase() ==
                      clientProvider.pressedBy.toLowerCase());
            }
            print('============ team index is ${eventController.team}');
            if (eventController.team < teamsController.ongoingTeams.length) {
              if (map['value'] == 'correct') {
                Get.find<QuestionController>().playCorrectSong();
                teamsController
                    .ongoingTeams[eventController.team].team.rapidRound++;
                teamsController
                    .ongoingTeams[eventController.team].team.scores++;
              } else if (map['value'] == 'wrong') {
                if (clientProvider.ongoinQuestion!.round == 'rapid') {
                  Get.find<QuestionController>().playWrongSong();
                } else if (clientProvider.ongoinQuestion!.round == 'buzzer') {
                  Get.find<QuestionController>().playBuzzer();
                  teamsController
                      .ongoingTeams[eventController.team].team.buzzerWrong++;
                }
              }
            }
          }
        } else if (map['todo'] == 'answer') {
          Get.find<QuestionController>()
              .checkAns(clientProvider.ongoinQuestion!.question!, map['value']);
        } else if (map['todo'] == 'eventId') {
          clientProvider.eventId = int.parse(map['value']);
          if (nameController.value.text.trim() != 'admin') {
            clientProvider.getTeamDetail();
          }
        } else if (map['todo'] == 'buzzer') {
          clientProvider.changePressedBy(name: map['value']);

          if (nameController.value.text.trim() == 'admin1' &&
              map['value'] != '-1') {
            Get.find<QuestionController>().playBuzzerPressed();
          }
        } else if (map['todo'] == 'issue') {
          EasyLoading.show(status: map['value'], dismissOnTap: true);
        } else if (map['todo'] == 'connected' ||
            map['todo'] == 'disconnected') {
          EasyLoading.dismiss();
          //EasyLoading.showToast(v.value, dismissOnTap: true);
          clientProvider.addConnectedTeam(
              teamName: map['value'], toAdd: map['todo'] == 'connected');
          if (map['todo'] == 'connected') {
            if (Get.find<ClientGetController>()
                        .nameController
                        .value
                        .text
                        .toLowerCase() ==
                    'admin' &&
                map['value'] == 'admin') {
              Get.offAll(const DashBoardScreen());
            } else if (Get.find<ClientGetController>()
                        .nameController
                        .value
                        .text
                        .toLowerCase() ==
                    'admin1' &&
                map['value'] == 'admin1') {
              Get.to(ServerQuizScreen(''));
            } else if (Get.find<ClientGetController>()
                    .nameController
                    .value
                    .text
                    .toLowerCase() ==
                map['value']) {
              Get.to(const QuizScreen());
            }
          }
        }
      } else if (res == 2) {
        try {
          // if (nameController.value.text != 'admin' && ) {
          //   QuestionController qcontroller = Get.find<QuestionController>();
          //   if (qcontroller.animationController != null) {
          //     // qcontroller.removeListener(() {});
          //     // qcontroller.animationController!.dispose();
          //     // qcontroller.animationController.duration

          //     qcontroller.animationController!.reset();
          //   }
          // }

          // Map<String, dynamic> map = jsonDecode(message);
          OnGoingEvent ques = OnGoingEvent.fromJson(message);
          if (ques.round.toLowerCase() == 'buzzer') {
            Get.find<QuestionController>().timedOut = false;
          }
          clientProvider.updateOnGoingQUestion(ques);
        } catch (e) {
          print('-------------------issueee---------------');
          print(e);
        }
      }
    } catch (e) {}
  }

  handleMessages() async {
    try {
      clientProvider.socket!.listen(
        (data) {
          checkMessage(data);
        },
        onError: (error) {
          print('Error: $error');
          // clientProvider.removeSocket();
        },
        onDone: () async {
          print('Disconnected from the server.');
          clientProvider.removeSocket();
          await getConnectToServerDialogue(context: Get.context!);
        },
      );
    } catch (e) {}
  }

  void sendMessage(String message) {
    try {
      if (clientProvider.socket != null) {
        clientProvider.socket!.write(message);
      } else {
        print('Not connected to the server.');
      }
    } catch (e) {
      print(e);
    }
  }

  void disconnect() {
    clientProvider.socket?.destroy();
    print('Disconnected from the server.');
  }

  getIp() async {
    try {
      // Get a list of network interfaces
      List<NetworkInterface> interfaces = await NetworkInterface.list();

      // Loop through the interfaces
      for (NetworkInterface ni in interfaces) {
        // Check if the interface is a WiFi or cellular interface
        if (ni.name.startsWith('Wi') && Platform.isWindows) {
          // Get the gateway address of the WiFi interface
          List<InternetAddress> addresses = ni.addresses;
          for (InternetAddress address in addresses) {
            ipController.value.text = address.address;
          }
        }
        if ((ni.name.startsWith('en') || ni.name.startsWith('wl')) &&
            !Platform.isWindows) {
          // Get the IP address of the interface
          List<InternetAddress> addresses = ni.addresses;
          for (InternetAddress address in addresses) {
            // Check if it's a valid IPv4 address
            if (address.type == InternetAddressType.IPv4) {
              ipController.value.text = address.address;
            }
          }
        }
      }
    } catch (ex) {
      print('Could not load IP address: $ex');
      return null;
    }
    return ipController.value.text;
  }
}
