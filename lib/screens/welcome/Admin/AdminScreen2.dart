import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quiz_competition_flutter/Client/ClientDetails.dart';
import 'package:quiz_competition_flutter/Client/Clients.dart';
import 'package:quiz_competition_flutter/controllers/EventsController.dart';
import 'package:quiz_competition_flutter/controllers/TeamsController.dart';
import 'package:quiz_competition_flutter/controllers/question_controller.dart';
import 'package:quiz_competition_flutter/screens/serverside/components/question_card.dart';

import '../../../constants.dart';
import '../../../models/MyMessage.dart';
import '../../quiz/components/progress_bar.dart';
import '../../serverside/dashboard.dart';
import '../../serverside/widgets/que_screen.dart';

class AdminScreen2 extends StatefulWidget {
  const AdminScreen2({super.key});

  @override
  State<AdminScreen2> createState() => _AdminScreen2State();
}

class _AdminScreen2State extends State<AdminScreen2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Get.find<QuestionController>().eventId = 1;
    getQuestions('');
  }

  getQuestions(String round) async {
    await context.read<ClientProvider>().getQuestions();
    sendDetail();
    //setState(() {});
  }

  sendDetail() async {
    try {
      // List<String> teamNames= Get.find<TeamsController>().ongoingTeams.map((e) => e.team.teamName).toList();

      await Future.delayed(const Duration(seconds: 2)).then((value) {
        Get.find<ClientGetController>().sendMessage(MyMessage(
                todo: 'teams',
                value: Get.find<TeamsController>()
                    .ongoingTeams
                    .map((e) => e.team.teamName)
                    .toList()
                    .join(','))
            .toJson());
      });
      Future.delayed(const Duration(seconds: 1)).then((value) {
        Get.find<ClientGetController>().sendMessage(MyMessage(
                todo: 'eventId',
                value: context.read<ClientProvider>().eventId.toString())
            .toJson());
      });
      // Get.find<ClientGetController>().sendMessage(MyMessage(
      //         todo: 'round', value: context.read<ClientProvider>().round ?? '')
      //     .toJson());
    } catch (e) {
      EasyLoading.show(status: 'when sending eventid and teams:  $e');
    }
  }

  late ClientProvider clientProvider;
  QuestionController questionController = Get.find<QuestionController>();
  @override
  Widget build(BuildContext context) {
    clientProvider = context.read<ClientProvider>();
    return Scaffold(
        backgroundColor: Colors.white,
        // backgroundColor=Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              var c = Get.find<QuestionController>();
              c.allQuestions = [];

              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return const DashBoardScreen();
                },
              ));
            },
            icon: Container(
              height: 40,
              width: 80,
              decoration: BoxDecoration(
                color: kGrayColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          // Fluttter show the back button automatically
          backgroundColor: Colors.transparent,
          elevation: 0,
          //actions: const [],
        ),
        body: (context.watch<ClientProvider>().showQuestinos)
            ? Stack(
                // fit: StackFit.expand,
                children: [
                  SvgPicture.asset("assets/icons/bg.svg",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth),
                  getQuestionBody(),
                ],
              )
            : Center(
                child: getConnectingScreen(
                    clientProvider: clientProvider, context: context),
              ));
  }

  Widget getQuestionBody() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: ProgressBar(),
        ),

        const SizedBox(height: kDefaultPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text.rich(
                TextSpan(
                  text:
                      "Question ${context.watch<ClientProvider>().questionNo + 1}",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: kSecondaryColor),
                  children: [
                    TextSpan(
                      text:
                          "/${context.watch<ClientProvider>().questions.length}",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: kSecondaryColor),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
                width: context.width * 0.4,
                child: FittedBox(child: getButtonsWidget()))
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        context.watch<ClientProvider>().questions.isEmpty
            ? Center(
                child: Lottie.asset('assets/noQuestion.json',
                    width: context.isPhone
                        ? context.width * 0.9
                        : context.width * 0.6,
                    height: context.isPhone
                        ? context.height * 0.6
                        : context.height * 0.8),
              )
            : Expanded(
                child: PageView.builder(
                  // Block swipe to next qn
                  physics: const NeverScrollableScrollPhysics(),
                  controller: clientProvider.pageController,
                  //onPageChanged: questionController.updateTheQnNum,
                  itemCount: context.watch<ClientProvider>().questions.length,
                  itemBuilder: (context, index) =>
                      QuestionCard(question: clientProvider.questions[index]),
                ),
              ),
        const SizedBox(
          height: 10,
        )
        // const Divider(thickness: 1.5),
        // const SizedBox(height: kDefaultPadding),
        // const Body(),
      ],
    );
  }

  Widget getButtonsWidget() {
    return Row(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Round: ',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<String>(
                // dropdownColor: Colors.white,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    // labelText
                    border: OutlineInputBorder(),
                    suffixIconColor: Colors.white),

                value: clientProvider.round,
                items: ['mcq', 'rapid', 'buzzer']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) async {
                  clientProvider.round = value;
                  Get.find<EventController>().team = 0;
                  Get.find<EventController>().teamName.value =
                      Get.find<TeamsController>()
                          .ongoingTeams[0]
                          .team
                          .teamName
                          .toLowerCase();
                  clientProvider.pressedBy = '-1';
                  await clientProvider.getQuestions();
                  // setState(() {});
                },
              ),
            )
          ],
        ),
        const SizedBox(
          width: 50,
        ),
        Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      clientProvider.nextQuestion();
                    },
                    child: const Text('Skip')),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                    onPressed: () async {
                      clientProvider.changeHiddenState(
                          toHide: clientProvider.isHidden ? false : true);
                      Get.find<ClientGetController>().sendMessage(MyMessage(
                              todo: 'hide',
                              value: (clientProvider.isHidden).toString())
                          .toJson());
                    },
                    child: Text(context.watch<ClientProvider>().isHidden
                        ? 'Show'
                        : 'Hide')),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      clientProvider.previousQuestion();
                    },
                    child: const Text('Back')),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                    onPressed: () async {
                      clientProvider.nextQuestion();
                    },
                    child: const Text('Next')),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  clientProvider.changeResultScreenState(
                      toHide: !clientProvider.isResultShowing);
                  Get.find<ClientGetController>().sendMessage(MyMessage(
                          todo: 'result',
                          value: (clientProvider.isResultShowing).toString())
                      .toJson());
                },
                child: Text(!context.watch<ClientProvider>().isResultShowing
                    ? 'View Result'
                    : 'Hide Result')),
          ],
        ),
      ],
    );
  }
}
