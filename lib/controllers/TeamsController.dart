import 'package:get/get.dart';

import '../models/OnGoingTeamsModel.dart';

class TeamsController extends GetxController {
  List<OnGoingTeams> ongoingTeams = [];
  // RxInt connectedTeams = (-1).obs;
  // getTeamsDetail() async {
  //   print('aerwnnwne');
  //   ongoingTeams.value = await client.members
  //       .getMembersDetail(eventId: Get.find<QuestionController>().eventId);
  //   print(ongoingTeams);
  //   // connectedTeams.value = 0;

  //   // connectedTeams.value = ongoingTeams.length;
  // }
}
