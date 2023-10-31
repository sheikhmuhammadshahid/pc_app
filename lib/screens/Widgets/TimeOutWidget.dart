import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_competition_flutter/Client/Clients.dart';
import 'package:quiz_competition_flutter/models/MyMessage.dart';

getTimeOutDialogue() {
  showCupertinoDialog(
    context: Get.context!,
    builder: (context) => AlertDialog(
      content: LottieBuilder.asset(
        'assets/timeOut.json',
        height: 200,
        width: 200,
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Get.find<ClientGetController>().sendMessage(
                  MyMessage(todo: 'NextTeam', value: 'next').toJson());
              Get.back();
            },
            child: const Text('Next Team')),
        ElevatedButton(
            onPressed: () {
              Get.find<ClientGetController>().sendMessage(
                  MyMessage(todo: 'NextTeam', value: 'continue').toJson());
              Get.back();
            },
            child: const Text('Continue'))
      ],
    ),
  );
}
