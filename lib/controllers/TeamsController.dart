import 'package:get/get.dart';
import 'package:pc_app/controllers/question_controller.dart';
import 'package:pc_app/models/TeamModel.dart';

import '../Apis/ApisFunctions.dart';

class TeamsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List<team> teams = [];
  RxInt connectedTeams = 0.obs;
  getTeamsDetail() async {
    teams = await getTeamsDetails(Get.find<QuestionController>().eventId);
    for (int i = 0; i < teams.length; i++) {
      teams[i].buzzerRound = 0;
      teams[i].rapidRound = 0;
      teams[i].buzzerWrong = 0;
      teams[i].mcqRound = 0;
      teams[i].scores = 0;
    }
  }
}
