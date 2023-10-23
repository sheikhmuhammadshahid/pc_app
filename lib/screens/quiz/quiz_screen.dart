import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quiz_competition_flutter/Client/ClientDetails.dart';
import 'package:quiz_competition_flutter/screens/quiz/components/question_card.dart';

import '../../controllers/question_controller.dart';
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
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            // leading: GestureDetector(
            //   onTap: () {
            //     var c = Get.find<QuestionController>();
            //     c.allQuestions = [];

            //     Get.put(WelcomeScreen());
            //   },
            //   child: const Icon(
            //     Icons.arrow_back,
            //     color: Colors.black,
            //   ),
            // ),
            automaticallyImplyLeading: false,
            // Fluttter show the back button automatically
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: const [
              // if (controller.round!.contains("buz"))
              //   TextButton(
              //       onPressed: controller.nextQuestion,
              //       child: const Text(
              //         "Skip",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //         ),
              //       )),
            ],
          ),
          body: context.watch<ClientProvider>().isHidden
              ? const Center(
                  child: Text('Event is pauesed by the admin'),
                )
              : context.watch<ClientProvider>().ongoinQuestion != null
                  ? clientProvider.ongoinQuestion!.question != null
                      ? Center(
                          child: QuestionCard(
                              question:
                                  clientProvider.ongoinQuestion!.question))
                      : const Center(
                          child: Text('No questions found'),
                        )
                  : const Center(
                      child: Text('Question will be shown here!'),
                    ),

          // : const Center(
          //     child: CircularProgressIndicator(),
          //   )
        ),
      ],
    );
  }
}
