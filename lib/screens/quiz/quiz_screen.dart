import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quiz_competition_flutter/Client/ClientDetails.dart';
import 'package:quiz_competition_flutter/Client/Clients.dart';
import 'package:quiz_competition_flutter/models/MyMessage.dart';
import 'package:quiz_competition_flutter/screens/quiz/components/question_card.dart';

import '../../controllers/question_controller.dart';
import '../serverside/widgets/que_screen.dart';
import '../welcome/welcome_screen.dart';
import 'components/body.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuestionController controller;

  // RxBool isLoading = true.obs;
  late ClientProvider clientProvider;
  @override
  Widget build(BuildContext context) {
    clientProvider = context.read<ClientProvider>();
    return
        // !isLoading.value
        //   ?
        Stack(
      children: [
        SvgPicture.asset("assets/icons/bg.svg",
            width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
        !(context.watch<ClientProvider>().showQuestinos)
            ? getConnectingScreen(
                context: context, clientProvider: clientProvider)
            : context.watch<ClientProvider>().isHidden
                ? const Center(
                    child: Text('Event is pauesed by the admin',
                        style: TextStyle(color: Colors.white)),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (clientProvider.ongoinQuestion != null)
                        if (clientProvider.ongoinQuestion!.round
                                .toLowerCase() ==
                            'buzzer')
                          // if(clientProvider.ongoinQuestion)
                          GestureDetector(
                            onTap: () async {
                              if (clientProvider.pressedBy == "-1") {
                                ClientGetController clientGetController =
                                    Get.find<ClientGetController>();
                                clientGetController.sendMessage(MyMessage(
                                        todo: 'buzzer',
                                        value: clientGetController
                                            .nameController.value.text
                                            .trim())
                                    .toJson());
                              }
                            },
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor:
                                  context.watch<ClientProvider>().pressedBy ==
                                          Get.find<ClientGetController>()
                                              .nameController
                                              .value
                                              .text
                                              .trim()
                                      ? Colors.green
                                      : clientProvider.pressedBy == '-1'
                                          ? Colors.red
                                          : Colors.grey,
                            ),
                          ),
                      const SizedBox(
                        height: 10,
                      ),
                      context.watch<ClientProvider>().ongoinQuestion != null
                          ? clientProvider.ongoinQuestion!.question != null
                              ? Center(
                                  child: QuestionCard(
                                      question: clientProvider
                                          .ongoinQuestion!.question))
                              : const Center(
                                  child: Text('No questions found',
                                      style: TextStyle(color: Colors.white)),
                                )
                          : const Center(
                              child: Text(
                                'Question will be shown here!',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ],
                  ),

        // : const Center(
        //     child: CircularProgressIndicator(),
        //   )
      ],
    );
  }
}
