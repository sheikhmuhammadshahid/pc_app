import 'package:get/get.dart';
import 'package:pc_app/Apis/ApisFunctions.dart';
import 'package:pc_app/models/Event.dart';

class EventController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList eventssList = [].obs;
  RxBool isLoading = true.obs;
  eventss? onGoingEvent;
  int team = 0;

  RxString teamName = "".obs;

  getEventsList() async {
    eventssList.value = await getEventsLists();
    isLoading.value = false;
    return eventssList.value;
    //notifyChildrens();
  }

  // QuestionController controller = Get.put(QuestionController());
  // startTimer() {
  //   controller.animationController!.repeat();
  // }
}
