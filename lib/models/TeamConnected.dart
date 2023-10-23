import 'package:get/get.dart';

import 'TeamModel.dart';

class TeamConnected extends GetxController {
  late TeamModel team;
  RxString status = 'pending'.obs;
}
