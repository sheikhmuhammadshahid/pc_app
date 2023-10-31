import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quiz_competition_flutter/controllers/TeamsController.dart';
import 'package:quiz_competition_flutter/models/TeamModel.dart';

import '../../constants.dart';

class ResultScreen extends StatefulWidget {
  final String round;

  const ResultScreen({Key? key, required this.round}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

Path drawStar(Size size) {
  // Method to convert degree to radians
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  bool isPlaying = false;
  late ConfettiController _controllerTopCenter;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<Offset> _offsetAnimation1;
  late Animation<Offset> _offsetAnimation2;
  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  List<PlutoRow> getRows({required int teamIndex}) {
    TeamModel team = teamController.ongoingTeams[teamIndex].team;

    return [
      PlutoRow(
        cells: {
          '1': PlutoCell(value: 'MCQS'),
          '2': PlutoCell(value: team.mcqRound.toString()),
          '3': PlutoCell(value: '-'),
          '4': PlutoCell(value: team.mcqRound.toString()),
        },
      ),
      PlutoRow(
        cells: {
          '1': PlutoCell(value: 'Rapid'),
          '2': PlutoCell(value: team.rapidRound.toString()),
          '3': PlutoCell(value: '-'),
          '4': PlutoCell(value: team.rapidRound.toString()),
        },
      ),
      PlutoRow(
        cells: {
          '1': PlutoCell(value: 'Buzzer'),
          '2': PlutoCell(value: team.buzzerRound.toString()),
          '3': PlutoCell(value: '${team.buzzerWrong} x 2'),
          '4': PlutoCell(
              value: (team.buzzerRound - (team.buzzerWrong * 2)).toString()),
        },
      ),
      PlutoRow(
        cells: {
          '1': PlutoCell(value: 'Total'),
          '2': PlutoCell(
              value: (team.mcqRound + team.rapidRound + team.buzzerRound)
                  .toString()),
          '3': PlutoCell(value: (team.buzzerWrong * 2).toString()),
          '4': PlutoCell(
              value: ((team.mcqRound + team.rapidRound + team.buzzerRound) -
                      (team.buzzerWrong * 2))
                  .toString()),
        },
      )
    ];
  }

  final _columns = [
    PlutoColumn(
        enableColumnDrag: false,
        title: 'Round',
        field: '1',
        type: PlutoColumnType.text(),
        width: 100,
        suppressedAutoSize: true),
    PlutoColumn(
        enableColumnDrag: false,
        title: 'Correct',
        field: '2',
        width: 100,
        type: PlutoColumnType.text(),
        suppressedAutoSize: true),
    PlutoColumn(
        title: 'Wrong',
        enableColumnDrag: false,
        field: '3',
        type: PlutoColumnType.text(),
        suppressedAutoSize: true),
    PlutoColumn(
        title: 'Total',
        enableColumnDrag: false,
        field: '4',
        type: PlutoColumnType.text(),
        suppressedAutoSize: true),
  ];
  @override
  void initState() {
    super.initState();
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 5));
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _offsetAnimation1 = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _offsetAnimation2 = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _controller.forward();
    checkResult();
  }

  int winner = -1;
  checkResult() {
    for (int i = 0; i < teamController.ongoingTeams.length; i++) {
      TeamModel team = teamController.ongoingTeams[i].team;
      teamController.ongoingTeams[i].team.scores =
          ((team.mcqRound + team.rapidRound + team.buzzerRound) -
              (team.buzzerWrong * 2));
    }

    teamController.ongoingTeams
        .sort((a, b) => b.team.scores.compareTo(a.team.scores));

    if (teamController.ongoingTeams.isNotEmpty) {
      winner = teamController.ongoingTeams
          .where((element) =>
              element.team.scores == teamController.ongoingTeams[0].team.scores)
          .toList()
          .length;
    } else {
      winner = -1;
    }
    setState(() {});
  }

  TeamsController teamController = Get.find<TeamsController>();
  @override
  Widget build(BuildContext context) {
    setState(() {
      _controllerTopCenter.play();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              itemCount: teamController.ongoingTeams.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                // childAspectRatio: 4.2 / 1.9,
                crossAxisCount: context.isPhone ? 1 : 2,
              ),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          teamController.ongoingTeams[index].team.teamName,
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 30),
                        )),
                    Card(
                      color: careem,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 40,
                            left: 10,
                            right: 10,
                            bottom: 10,
                          ),
                          child: PlutoGrid(
                            mode: PlutoGridMode.readOnly,
                            configuration: PlutoGridConfiguration(
                              style: PlutoGridStyleConfig(
                                gridBackgroundColor: Colors.transparent,
                                rowColor: Colors.transparent,
                                borderColor: Colors.black,
                                gridBorderColor: Colors.black,
                                gridBorderRadius: BorderRadius.circular(12),
                                //rowColor: btnColor,
                                columnTextStyle: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                                cellTextStyle: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                                activatedBorderColor: Colors.black,
                                enableGridBorderShadow: true,
                              ),
                            ),
                            onChanged: (PlutoGridOnChangedEvent event) {},
                            onLoaded: (PlutoGridOnLoadedEvent event) {},
                            noRowsWidget: const Center(
                              child: Text(
                                'Scores will be show here!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            columns: _columns,
                            rows: getRows(teamIndex: index),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          if (widget.round == 'buzzer') ...{
            SlideTransition(
              position: _offsetAnimation2,
              child: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          winner == -1 || winner == 1
                              ? "Congratulations!"
                              : 'Draw',
                          style: const TextStyle(
                              fontSize: 40,
                              color: Color(0xffFFBA07),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: context.height * 0.75,
                                width: 500,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: (0.05)),
                                      child: Lottie.asset(
                                        'assets/winner.json',
                                        width: 500,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        teamController.ongoingTeams.isNotEmpty
                                            ? teamController
                                                .ongoingTeams[0].team.teamName
                                            : 'No Teams',
                                        style: const TextStyle(
                                          fontSize: 40,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(
                            height: context.height * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FittedBox(
                                  fit: BoxFit.fill,
                                  child: Wrap(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(
                                    teamController.ongoingTeams.isNotEmpty
                                        ? teamController
                                            .ongoingTeams[0].members.length
                                        : 0,
                                    (index) => SlideTransition(
                                      position: _offsetAnimation,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  const Color(0xff5A88B0),
                                              radius: 80,
                                              child: getImageBuilder(
                                                  teamController.ongoingTeams[0]
                                                      .members[index].image),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              child: Container(
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: careem,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          255, 194, 192, 192),
                                                      blurRadius: 6.0,
                                                      spreadRadius: 2.0,
                                                      offset: Offset(0.0, 0.0),
                                                    )
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(
                                                      teamController
                                                          .ongoingTeams[0]
                                                          .members[index]
                                                          .name,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ConfettiWidget(
              numberOfParticles: 100,
              blastDirectionality: BlastDirectionality.explosive,
              confettiController: _controllerTopCenter,
              shouldLoop:
                  true, // start again as soon as the animation is finished
              colors: const [
                Color.fromARGB(255, 43, 247, 50),
                Color.fromARGB(255, 1, 141, 255),
                Color.fromARGB(255, 255, 0, 85),
                Color.fromARGB(255, 255, 157, 9),
                Color.fromARGB(255, 217, 0, 255),
                Color.fromARGB(255, 183, 255, 0),
                Color.fromARGB(255, 0, 72, 131),
                Color.fromARGB(255, 189, 0, 63),
                Color.fromARGB(255, 214, 9, 255),
                Color.fromARGB(255, 200, 255, 0),
              ], // manually specify the colors to be used
              createParticlePath: drawStar, // define a custom shape/path.
            )
          }
        ],
      ),
    );
  }

  getImageBuilder(url) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter:
                  const ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
        ),
      ),
      progressIndicatorBuilder: (context, url, progress) =>
          CircularProgressIndicator(
        value: progress.progress,
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.person,
        size: 60,
      ),
    );
  }
}
