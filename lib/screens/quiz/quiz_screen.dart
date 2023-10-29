import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quiz_competition_flutter/Client/ClientDetails.dart';
import 'package:quiz_competition_flutter/Client/Clients.dart';
import 'package:quiz_competition_flutter/models/MyMessage.dart';
import 'package:quiz_competition_flutter/screens/quiz/components/question_card.dart';

import '../../constants.dart';
import '../../controllers/question_controller.dart';
import 'components/progress_bar.dart';

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
        // !(context.watch<ClientProvider>().showQuestinos)
        //     ? getConnectingScreen(
        //         context: context, clientProvider: clientProvider)
        //     :
        context.watch<ClientProvider>().isHidden
            ? getLotties(context: context, lotties: 'assets/paused.json')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  if (clientProvider.ongoinQuestion != null) ...{
                    if (clientProvider.ongoinQuestion!.round == 'buzzer')
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: ProgressBar(),
                      ),
                  },
                  const SizedBox(height: kDefaultPadding),
                  if (clientProvider.ongoinQuestion != null)
                    if (clientProvider.ongoinQuestion!.round.toLowerCase() ==
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

                            try {
                              Get.find<QuestionController>()
                                  .animationController!
                                  .duration = const Duration(seconds: 7);
                              Get.find<QuestionController>()
                                  .animationController!
                                  .reset();
                              Get.find<QuestionController>()
                                  .animationController!
                                  .forward();
                            } catch (e) {}
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
                                  question:
                                      clientProvider.ongoinQuestion!.question))
                          : getLotties(
                              context: context,
                              lotties: 'assets/noQuestion.json')
                      : getLotties(
                          context: context, lotties: 'assets/paused.json')
                ],
              ),

        // : const Center(
        //     child: CircularProgressIndicator(),
        //   )
      ],
    );
  }

  Widget getLotties({required BuildContext context, required String lotties}) {
    return Center(
      child: Lottie.asset(lotties,
          width: context.isPhone ? context.width * 0.9 : context.width * 0.6,
          height:
              context.isPhone ? context.height * 0.6 : context.height * 0.8),
    );
  }
}
