import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quiz_competition_flutter/Client/ClientDetails.dart';
import 'package:quiz_competition_flutter/models/MyMessage.dart';

import '../../../Client/Clients.dart';
import '../../../constants.dart';
import '../../../controllers/question_controller.dart';
import '../../../models/Question.dart';
import 'option.dart';

class QuestionCard extends StatelessWidget {
  QuestionCard({
    super.key,
    // it means we have to pass this
    @required this.question,
  });
  var quesController = Get.find<QuestionController>();
  var clientController = Get.find<ClientGetController>();
  Question? question;
  Rx<Color> QBColor =
      const Color.fromARGB(255, 206, 198, 247).withOpacity(.6).obs;
  late QuestionController controller;
  late ClientProvider clientProvider;
  @override
  Widget build(BuildContext context) {
    controller = Get.find<QuestionController>();
    clientProvider = context.read<ClientProvider>();
    return Container(
      height: context.isPhone ? null : context.height * 0.8,
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: SingleChildScrollView(
        child: !context.isPhone
            ? Row(
                children: getWidgets(context: context),
              )
            : Column(
                children: getWidgets(context: context),
              ),
      ),
    );
  }

  List<Widget> getWidgets({required BuildContext context}) {
    return [
      Obx(
        () {
          return GestureDetector(
            onTap: () {
              if (clientProvider.round == 'buzzer') {
                QBColor.value =
                    const Color.fromARGB(255, 254, 180, 180).withOpacity(.6);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(top: kDefaultPadding),
              padding: const EdgeInsets.all(kDefaultPadding * 0.9),
              width: context.isPhone
                  ? context.width
                  : clientProvider.round != 'rapid'
                      ? MediaQuery.of(context).size.width * .45
                      : MediaQuery.of(context).size.width * .6,
              decoration: BoxDecoration(
                color: QBColor.value,
                border:
                    Border.all(color: const Color.fromARGB(255, 154, 182, 248)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                question!.ques,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black),
              ),
            ),
          );
        },
      ),
      const SizedBox(
        height: kDefaultPadding / 2,
        width: kDefaultPadding / 2,
      ),
      if (clientProvider.ongoinQuestion!.round != 'rapid') ...{
        SizedBox(
          width: context.isPhone ? context.width : context.width * .45,
          child: Column(
            children: [
              Option(
                index: 0,
                text: question!.opt1,
                press: () {
                  checkAnswer(question!.opt1);
                },
              ),
              Option(
                index: 1,
                text: question!.opt2,
                press: () {
                  checkAnswer(question!.opt2);
                },
              ),
              Option(
                index: 2,
                text: question!.opt3,
                press: () {
                  checkAnswer(question!.opt3);
                },
              ),
              Option(
                index: 3,
                text: question!.opt4,
                press: () {
                  checkAnswer(question!.opt4);
                },
              )
            ],
          ),
        )
      }
    ];
  }

  checkAnswer(option) async {
    try {
      if (clientController.nameController.value.text != 'admin1') {
        if ((clientProvider.ongoinQuestion!.question!.type.toLowerCase() !=
                    'buzzer' &&
                clientProvider.ongoinQuestion!.questionForTeam
                        .toLowerCase()
                        .trim() ==
                    clientController.nameController.value.text
                        .toLowerCase()
                        .trim()) ||
            (clientProvider.ongoinQuestion!.question!.type.toLowerCase() ==
                    'buzzer' &&
                clientProvider.pressedBy.toLowerCase() ==
                    clientController.nameController.value.text.toLowerCase() &&
                !quesController.timedOut)) {
          try {
            if (clientProvider.ongoinQuestion!.round == 'buzzer') {
              quesController.animationController!.stop();
            }
          } catch (e) {}
          if (!controller.isAnswered.value) {
            // clientController
            //     .sendMessage("#1#${quesController.questionNumber.value}");

            clientController
                .sendMessage(MyMessage(todo: 'answer', value: option).toJson());
            controller.checkAns(question!, option);
          }
        }
      }
    } catch (e) {}
  }
}
