import 'package:get/get.dart';
import 'package:pc_app/Apis/ApisFunctions.dart';
import 'package:pc_app/models/Event.dart';

class EventController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList eventssList = [].obs;
  RxBool isLoading = true.obs;
  eventss? onGoingEvent;
  int team = 0;
  RxList filteredEvents = [].obs;

  RxString teamName = "".obs;
  appLyFilter({required String text}) async {
    try {
      if (text == 'Recent') {
        filteredEvents.value = eventssList
            .where((element) => element.status == 'Completed')
            .toList();
      } else if (text == 'Today') {
        filteredEvents.value = eventssList
            .where((element) =>
                DateTime.parse(element.date).compareTo(DateTime.now()) == 0)
            .toList();
      } else if (text == 'Pending') {
        filteredEvents.value = eventssList
            .where((element) =>
                DateTime.parse(element.date).compareTo(DateTime.now()) != 0)
            .toList();
      } else {
        filteredEvents.value = eventssList
            .where((element) =>
                (element.type.toLowerCase().contains(text.toLowerCase()) ||
                    element.date.toLowerCase().contains(text.toLowerCase())))
            .toList();
      }
    } catch (e) {}
  }

  getEventsList() async {
    eventssList.value = await getEventsLists();
    filteredEvents.value = eventssList;
    isLoading.value = false;

    return eventssList;
    //notifyChildrens();
  }

  // QuestionController controller = Get.put(QuestionController());
  // startTimer() {
  //   controller.animationController!.repeat();
  // }
}
