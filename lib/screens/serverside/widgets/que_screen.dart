import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quiz_competition_flutter/Client/ClientDetails.dart';
import 'package:quiz_competition_flutter/main.dart';

import '../../../Client/Clients.dart';
import '../../../constants.dart';
import '../../../controllers/TeamsController.dart';
import '../../../controllers/question_controller.dart';
import '../../quiz/components/question_card.dart';
import '../components/body.dart';
import '../dashboard.dart';

class ServerQuizScreen extends StatefulWidget {
  late String round;
  ServerQuizScreen(this.round, {super.key});

  @override
  State<ServerQuizScreen> createState() => _ServerQuizScreenState();
}

class _ServerQuizScreenState extends State<ServerQuizScreen> {
  var teamController = Get.find<TeamsController>();
  @override
  void initState() {
    super.initState();
    // getqus();
    // getTeamDetails();
  }

  QuestionController controller = Get.find<QuestionController>();

  bool isLoading = true;
  late ClientProvider clientProvider;
  @override
  Widget build(BuildContext context) {
    clientProvider = context.read<ClientProvider>();
    return Scaffold(
      body: !(context.watch<ClientProvider>().showQuestinos)
          ? getConnectingScreen(
              context: context, clientProvider: clientProvider)
          : context.watch<ClientProvider>().isHidden
              ? const Center(
                  child: Text('Event is pauesed by the admin',
                      style: TextStyle(color: Colors.white)),
                )
              : (context.watch<ClientProvider>().ongoinQuestion != null)
                  ? context.watch<ClientProvider>().ongoinQuestion!.question !=
                          null
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: kDefaultPadding),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text.rich(
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
                                                  .copyWith(
                                                      color: kSecondaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.teal,
                                        child: FittedBox(
                                          child: Text(clientProvider.round ==
                                                  'buzzer'
                                              ? clientProvider.pressedBy == '-1'
                                                  ? ''
                                                  : clientProvider.pressedBy
                                              : clientProvider.ongoinQuestion!
                                                  .questionForTeam),
                                        ),
                                      )
                                    ],
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              QuestionCard(
                                  question:
                                      clientProvider.ongoinQuestion!.question)
                            ],
                          ),
                        )
                      : const Text('No questions found')
                  : const Text('Questions will be shown here'),
    );
  }
}

Widget getConnectingScreen(
    {required BuildContext context, required ClientProvider clientProvider}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: Container(
      height: MediaQuery.of(context).size.height / 1.6,
      width: MediaQuery.of(context).size.width / 1.62,
      color: const Color.fromARGB(255, 206, 198, 247).withOpacity(0.5),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: kGrayColor,
                  borderRadius: BorderRadius.circular(45),
                ),
                child: FutureBuilder(
                  future: ClientGetController().getIp(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Listening at ip Address: ${snapshot.data.toString()}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 2,
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              children: [
                const Wrap(
                  children: [
                    Text(
                      'Waiting...',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Colors.black,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Teams remaining : ${context.watch<ClientProvider>().ongoingTeams.length - context.watch<ClientProvider>().connectedTeams} ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 200,
              width: 700,
              //color: Colors.amber,
              child: Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      context.watch<ClientProvider>().ongoingTeams.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor:
                              context.watch<ClientProvider>().adminConnected
                                  ? Colors.green
                                  : Colors.red,
                          child: const FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "Admin",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    if (index == 1) {
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor:
                              context.watch<ClientProvider>().admin1Connected
                                  ? Colors.green
                                  : Colors.red,
                          child: const FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "Projector",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: context
                                .watch<ClientProvider>()
                                .connecteds
                                .any((element) =>
                                    element ==
                                    clientProvider
                                        .ongoingTeams[index - 2].team.teamName)
                            ? Colors.green
                            : Colors.red,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            " ${clientProvider.ongoingTeams[index - 2].team.teamName} ",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
