import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
// import 'package:quiz_competition_client/quiz_competition_client.dart';
import 'package:flutter/material.dart';
import 'package:quiz_competition_flutter/Client/ClientDetails.dart';
import 'package:quiz_competition_flutter/Client/Clients.dart';
import 'package:quiz_competition_flutter/EventController.dart';

import 'package:quiz_competition_flutter/controllers/EventsController.dart';
import 'package:quiz_competition_flutter/controllers/TeamsController.dart';
import 'package:quiz_competition_flutter/controllers/question_controller.dart';
// import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
// import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'models/MyMessage.dart';
import 'screens/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // sessionManager = SessionManager(
  //   caller: client.modules.auth,
  // );
  // await sessionManager.initialize();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ClientProvider(),
    )
  ], child: const MyApp()));
  configLoading();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // connectConnection();
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      if (state == AppLifecycleState.detached) {
        // The app is going into the background or is being killed
        // sendMessage();

        Get.find<ClientGetController>().sendMessage(MyMessage(
                todo: 'disconnected',
                value: Get.find<ClientGetController>()
                    .nameController
                    .value
                    .text
                    .trim())
            .toJson());
      } else if (state == AppLifecycleState.resumed) {
        if (Get.find<ClientGetController>()
            .nameController
            .value
            .text
            .isNotEmpty) {
          Get.find<ClientGetController>().sendMessage(MyMessage(
                  todo: 'connected',
                  value: Get.find<ClientGetController>()
                      .nameController
                      .value
                      .text
                      .trim())
              .toJson());
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Get.put(OnGoingEventController());
    Get.put(EventController());
    Get.put(ClientGetController());

    Get.put(QuestionController());
    Get.put(TeamsController());
    //Get.put(OnGoingEventController());

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        title: 'Serverpod Demo',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: WelcomeScreen());
  }
}
