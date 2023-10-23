import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quiz_competition_flutter/Client/ClientDetails.dart';
import 'package:quiz_competition_flutter/main.dart';

import '../../../Client/Clients.dart';
import '../../../constants.dart';
import '../../../controllers/TeamsController.dart';
import '../../../controllers/question_controller.dart';
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
    getqus();
    // getTeamDetails();
  }

  QuestionController controller = Get.find<QuestionController>();
  getqus() async {
    // controller.allQuestions = [];
    // await controller.getQuestions(widget.round, context: context);

    // setState(() {
    //   isLoading = false;
    // });
  }

  bool isLoading = true;
  late ClientProvider clientProvider;
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
            ? Body(
                round: widget.round,
              )
            : Center(
                child: getConnectingScreen(
                    clientProvider: clientProvider, context: context)));
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
                      context.watch<ClientProvider>().ongoingTeams.length,
                  itemBuilder: (context, index) {
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
                                        .ongoingTeams[index].team.teamName)
                            ? Colors.green
                            : Colors.red,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            " ${clientProvider.ongoingTeams[index].team.teamName} ",
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
