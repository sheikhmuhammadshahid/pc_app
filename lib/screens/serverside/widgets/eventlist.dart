import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pc_app/Client/Clients.dart';
import 'package:pc_app/constants.dart';
import 'package:pc_app/controllers/EventsController.dart';
import 'package:pc_app/controllers/question_controller.dart';
import 'package:pc_app/screens/AddEvent/AddMember.dart';
//import 'package:pc_app/screens/serverside/Model/Events.dart';
import 'package:pc_app/screens/serverside/widgets/que_screen.dart';
import 'package:pc_app/screens/welcome/Admin/AdminScreen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Apis/ApisFunctions.dart';
import '../../../models/Event.dart';
import '../../AddEvent/AddEvent.dart';
import 'eventcard.dart';

class RestaurantList extends StatefulWidget {
  //final List<eventss> restaurantList;

  const RestaurantList({
    Key? key,
    // required this.restaurantList,
  }) : super(key: key);

  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  var controller = Get.find<EventController>();
  var c = Get.find<QuestionController>();
  Client clientController = Get.find<Client>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Obx(() => controller.isLoading.value
          ? GridView.builder(
              itemCount: 7,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 20, crossAxisSpacing: 0),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white,
                    child: const Card());
              },
            )
          : RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1)).then((value) {
                  getEventsLists();
                  return true;
                });
              },
              child: GridView.builder(
                itemCount: controller.filteredEvents.value.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 2.5),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return FittedBox(
                      fit: BoxFit.fill,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Material(
                          shadowColor: kSecondaryColor.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                          elevation: 5,
                          child: InkWell(
                            onTap: () async {
                              await showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AddEventScreen();
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                            child: Container(
                              height: 260,
                              width: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10.0,
                                ),
                                color: const Color.fromARGB(255, 80, 217, 158)
                                    .withOpacity(0.3),
                              ),

                              //padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0)),
                                    child: SizedBox(
                                      width: 400,
                                      height: 140,
                                      child: AspectRatio(
                                        aspectRatio: 1.8,
                                        child: Image.asset(
                                          "assets/events.jpg",
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "Add An Event!",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Save an event to Start...",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return FittedBox(
                    fit: BoxFit.fill,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: EventCard(
                        onTap: () async {
                          await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor:
                                    const Color.fromARGB(255, 206, 198, 247)
                                        .withOpacity(.9),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: (() {
                                            Navigator.of(context).pop();
                                          }),
                                          icon: const Icon(
                                            color: Colors.black,
                                            Icons.cancel_outlined,
                                          ),
                                        ),
                                      ],
                                    ),
                                    getOptionWidget('MCQ', index),
                                    getOptionWidget('Rapid', index),
                                    getOptionWidget('Buzzer', index),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: SizedBox(
                                        height: 50,
                                        width: 160,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 5,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    218, 255, 255, 255),
                                          ),
                                          onPressed: () async {
                                            Get.back();
                                            Get.to(AddMembersScreen(
                                                event:
                                                    controller.filteredEvents[
                                                        index - 1]));

                                            // Navigator.push(context, MaterialPageRoute(
                                            //   builder: (context) {
                                            //     return ServerQuizScreen();
                                            //   },
                                            // ));
                                          },
                                          child: Text(
                                            "Update",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: SizedBox(
                                        height: 50,
                                        width: 160,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 5,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    218, 255, 255, 255),
                                          ),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await deleteEvent(controller
                                                .filteredEvents[index - 1]);
                                            eventss event = controller
                                                .filteredEvents[index - 1];
                                            controller.eventssList
                                                .remove(event);
                                            controller.filteredEvents
                                                .remove(event);

                                            // Navigator.push(context, MaterialPageRoute(
                                            //   builder: (context) {
                                            //     return ServerQuizScreen();
                                            //   },
                                            // ));
                                          },
                                          child: Text(
                                            "Delete",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        backgroundColor:
                            Colors.primaries[index % Colors.primaries.length],
                        restaurant: controller.filteredEvents[index - 1],
                      ),
                    ),
                  );
                },
              ),
            )),
      // : Wrap(
      //     children: List.generate(controller.filteredEvents.length + 1,
      //         (index) {
      //       if (index == 0) {
      //         return FittedBox(
      //           fit: BoxFit.fill,
      //           child: Material(
      //             borderRadius: BorderRadius.circular(
      //               10.0,
      //             ),
      //             color: const Color.fromARGB(255, 80, 217, 158)
      //                 .withOpacity(0.3),
      //             child: InkWell(
      //               onTap: () async {
      //                 await showCupertinoModalPopup(
      //                   context: context,
      //                   builder: (BuildContext context) {
      //                     return const AddEventScreen();
      //                   },
      //                 );
      //               },
      //               borderRadius: BorderRadius.circular(
      //                 10.0,
      //               ),
      //               child: Container(
      //                 height: 260,
      //                 width: context.width / 2,
      //                 padding: const EdgeInsets.all(20),
      //                 child: Column(
      //                   children: [
      //                     ClipRRect(
      //                       borderRadius: BorderRadius.circular(10.0),
      //                       child: SizedBox(
      //                         width: 400,
      //                         child: AspectRatio(
      //                           aspectRatio: 1.8,
      //                           child: Image.asset(
      //                             "assets/events.jpg",
      //                             errorBuilder:
      //                                 (context, error, stackTrace) =>
      //                                     const Icon(Icons.error),
      //                             fit: BoxFit.cover,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                     const Spacer(),
      //                     Text(
      //                       "Add An Event!",
      //                       style: GoogleFonts.montserrat(
      //                           fontSize: 16,
      //                           fontWeight: FontWeight.w700,
      //                           color: Colors.black),
      //                     ),
      //                     const SizedBox(height: 6),
      //                     Text(
      //                       "Save an event to Start...",
      //                       textAlign: TextAlign.center,
      //                       style: GoogleFonts.montserrat(
      //                         fontWeight: FontWeight.w500,
      //                         fontSize: 13,
      //                         color: Colors.grey.shade600,
      //                       ),
      //                     ),
      //                     const SizedBox(height: 5),
      //                     Material(
      //                       color: Colors.white,
      //                       borderRadius: BorderRadius.circular(50),
      //                       child: Container(
      //                         height: 45,
      //                         width: 45,
      //                         alignment: Alignment.center,
      //                         child: const Icon(
      //                           Icons.add,
      //                           color: Colors.black,
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ),
      //         );
      //       }

      //       return FittedBox(
      //         fit: BoxFit.fill,
      //         child: Padding(
      //           padding: const EdgeInsets.only(right: 30.0),
      //           child: EventCard(
      //             onTap: () async {
      //               await showDialog(
      //                 barrierDismissible: false,
      //                 context: context,
      //                 builder: (context) {
      //                   return AlertDialog(
      //                     backgroundColor:
      //                         const Color.fromARGB(255, 206, 198, 247)
      //                             .withOpacity(.9),
      //                     title: Column(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       children: [
      //                         Row(
      //                           mainAxisAlignment: MainAxisAlignment.end,
      //                           children: [
      //                             IconButton(
      //                               onPressed: (() {
      //                                 Navigator.of(context).pop();
      //                               }),
      //                               icon: const Icon(
      //                                 color: Colors.black,
      //                                 Icons.cancel_outlined,
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                         getOptionWidget('MCQ', index),
      //                         getOptionWidget('Rapid', index),
      //                         getOptionWidget('Buzzer', index),
      //                         Padding(
      //                           padding: const EdgeInsets.all(10),
      //                           child: SizedBox(
      //                             height: 50,
      //                             width: 160,
      //                             child: ElevatedButton(
      //                               style: ElevatedButton.styleFrom(
      //                                 elevation: 5,
      //                                 backgroundColor:
      //                                     const Color.fromARGB(
      //                                         218, 255, 255, 255),
      //                               ),
      //                               onPressed: () async {
      //                                 Get.back();
      //                                 Get.to(AddMembersScreen(
      //                                     event:
      //                                         controller.filteredEvents[
      //                                             index - 1]));

      //                                 // Navigator.push(context, MaterialPageRoute(
      //                                 //   builder: (context) {
      //                                 //     return ServerQuizScreen();
      //                                 //   },
      //                                 // ));
      //                               },
      //                               child: Text(
      //                                 "Update",
      //                                 style: GoogleFonts.montserrat(
      //                                     fontSize: 20,
      //                                     fontWeight: FontWeight.bold,
      //                                     color: Colors.black),
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                         Padding(
      //                           padding: const EdgeInsets.all(10),
      //                           child: SizedBox(
      //                             height: 50,
      //                             width: 160,
      //                             child: ElevatedButton(
      //                               style: ElevatedButton.styleFrom(
      //                                 elevation: 5,
      //                                 backgroundColor:
      //                                     const Color.fromARGB(
      //                                         218, 255, 255, 255),
      //                               ),
      //                               onPressed: () async {
      //                                 Navigator.pop(context);
      //                                 await deleteEvent(controller
      //                                     .filteredEvents[index - 1]);
      //                                 eventss event = controller
      //                                     .filteredEvents[index - 1];
      //                                 controller.eventssList
      //                                     .remove(event);
      //                                 controller.filteredEvents
      //                                     .remove(event);

      //                                 // Navigator.push(context, MaterialPageRoute(
      //                                 //   builder: (context) {
      //                                 //     return ServerQuizScreen();
      //                                 //   },
      //                                 // ));
      //                               },
      //                               child: Text(
      //                                 "Delete",
      //                                 style: GoogleFonts.montserrat(
      //                                     fontSize: 20,
      //                                     fontWeight: FontWeight.bold,
      //                                     color: Colors.black),
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   );
      //                 },
      //               );
      //             },
      //             backgroundColor:
      //                 Colors.primaries[index % Colors.primaries.length],
      //             restaurant: controller.filteredEvents[index - 1],
      //           ),
      //         ),
      //       );
      //     }),
      //   )));
    );
  }

  getOptionWidget(String text, index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 50,
        width: 160,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            backgroundColor: const Color.fromARGB(218, 255, 255, 255),
          ),
          onPressed: (() async {
            c.round = text.toLowerCase();

            c.eventId = controller.filteredEvents[index - 1].id;
            clientController.sendMessage('eventId:${c.eventId}');
            clientController.sendMessage('round:${c.round}');
            controller.onGoingEvent = controller.filteredEvents[index - 1];
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return Get.find<Client>()
                        .nameController
                        .value
                        .text
                        .toLowerCase()
                        .startsWith('adm')
                    ? const AdminScreen()
                    : ServerQuizScreen(text.toLowerCase());
              },
            ));
          }),
          child: Text(
            text,
            style: GoogleFonts.montserrat(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
