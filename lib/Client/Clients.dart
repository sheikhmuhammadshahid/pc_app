import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:quiz_competition_flutter/models/OnGoingEventModel.dart';
import 'package:quiz_competition_flutter/screens/quiz/quiz_screen.dart';

import '../models/MyMessage.dart';
import '../screens/serverside/dashboard.dart';
import 'ClientDetails.dart';

class ClientGetController extends GetxController {
  Rx<TextEditingController> ipController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  late ClientProvider clientProvider;
  RxInt isConnected = 0.obs;
  late MyMessage myMessage;

  connect(ip, port) async {
    try {
      Socket socket = await Socket.connect(ip, 1234);
      clientProvider.addSocket(socket);
      return socket;
    } catch (e) {
      print(e);
      EasyLoading.show(
          status: 'Server is not started yet.', dismissOnTap: true);

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
        sendMessage(
            MyMessage(todo: 'connected', value: nameController.value.text)
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

  handleMessages() async {
    try {
      clientProvider.socket!.listen(
        (data) {
          String message = String.fromCharCodes(data).trim();
          print('Received from server: $message');
          int res = isMyMessage(jsonDecode(message));
          print(res);
          if (res == 1) {
            Map<String, dynamic> map = jsonDecode(message);

            if (map['todo'] == 'hide') {
              clientProvider.changeHiddenState(
                  toHide: bool.tryParse(map['value']) ?? false);
            }
            if (map['todo'] == 'issue') {
              EasyLoading.show(status: map['value'], dismissOnTap: true);
            }
            if (map['todo'] == 'connected' || map['todo'] == 'disconnected') {
              EasyLoading.dismiss();
              //EasyLoading.showToast(v.value, dismissOnTap: true);
              clientProvider.addConnectedTeam(
                  teamName: map['value'], toAdd: map['todo'] == 'connected');
              if (map['todo'] == 'connected') {
                if (Get.find<ClientGetController>().nameController.value.text ==
                        'admin' &&
                    map['value'] == 'admin') {
                  Get.offAll(const DashBoardScreen());
                } else if (Get.find<ClientGetController>()
                            .nameController
                            .value
                            .text ==
                        'admin1' &&
                    map['value'] == 'admin1') {
                  Get.to(const QuizScreen());
                } else if (Get.find<ClientGetController>()
                        .nameController
                        .value
                        .text ==
                    map['value']) {
                  Get.to(const QuizScreen());
                }
              }
            }
          } else if (res == 2) {
            try {
              // Map<String, dynamic> map = jsonDecode(message);
              OnGoingEvent ques = OnGoingEvent.fromJson(message);
              clientProvider.updateOnGoingQUestion(ques);
            } catch (e) {
              print('-------------------issueee---------------');
              print(e);
            }
          }
        },
        onError: (error) {
          print('Error: $error');
          clientProvider.removeSocket();
        },
        onDone: () {
          print('Disconnected from the server.');
          clientProvider.removeSocket();
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
        // Check if the interface is a WiFi interface
        if (ni.name.startsWith('Wi')) {
          // Get the gateway address of the WiFi interface
          List<InternetAddress> addresses = ni.addresses;
          for (InternetAddress address in addresses) {
            ipController.value.text = address.address;
          }
        }
      }
    } catch (ex) {
      Get.snackbar('', 'Could not load IP address.\nTry Again');
    }
    return ipController.value.text;
  }
}
