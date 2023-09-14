import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pc_app/Client/ClientDetails.dart';
import 'package:pc_app/GetConnectToServerDialogue.dart';
import 'package:pc_app/controllers/EventsController.dart';

import 'package:pc_app/screens/serverside/widgets/eventcard.dart';
import 'package:pc_app/screens/serverside/widgets/eventlist.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  EventController? controller;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    controller = Get.find<EventController>();

    getEvents();
  }

  getEvents() async {
    await controller!.getEventsList();
    //serverController.startListening();
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: context.watch<ClientProvider>().socket == null
            ? AppBar(
                title: const Text(
                  'Not connected with server',
                  style: TextStyle(color: Colors.red),
                ),
                actions: [
                  IconButton(
                      onPressed: () async {
                        await getConnectToServerDialogue(context: context);
                      },
                      icon: const Icon(
                        Icons.restart_alt_rounded,
                        color: Colors.green,
                      ))
                ],
              )
            : null,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 3),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/societyLogo.png'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 15),
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: TextFormField(
                                    controller: searchController,
                                    onTapOutside: (event) {
                                      controller!.appLyFilter(
                                          text: searchController.text);
                                      FocusScope.of(context).unfocus();
                                    },
                                    onSaved: (newValue) {
                                      controller!
                                          .appLyFilter(text: newValue ?? '');
                                    },
                                    onFieldSubmitted: (value) {
                                      controller!.appLyFilter(text: value);
                                    },
                                    style: const TextStyle(color: Colors.grey),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                218, 255, 255, 255)),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      suffixIcon: IconButton(
                                        color: Colors.grey,
                                        icon: const Icon(Icons.search),
                                        onPressed: () {},
                                      ),
                                      hintText: 'Search an event...',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5),
                            child: SizedBox(
                              height: 40,
                              width: 140,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor:
                                      const Color.fromARGB(255, 206, 198, 247)
                                          .withOpacity(.9),
                                ),
                                onPressed: (() {
                                  controller!.appLyFilter(text: 'Recent');
                                }),
                                child: FittedBox(
                                  child: Text(
                                    "Recent",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const CustomDivider(height: 40),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5),
                            child: SizedBox(
                              height: 40,
                              width: 140,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor:
                                      const Color.fromARGB(255, 206, 198, 247)
                                          .withOpacity(.9),
                                ),
                                onPressed: (() {
                                  controller!.appLyFilter(text: 'Today');
                                }),
                                child: FittedBox(
                                  child: Text(
                                    "Today's",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const CustomDivider(height: 40),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: SizedBox(
                              height: 40,
                              width: 140,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor:
                                      const Color.fromARGB(255, 206, 198, 247)
                                          .withOpacity(.9),
                                ),
                                onPressed: (() {
                                  Get.find<EventController>()
                                      .appLyFilter(text: 'Pending');
                                }),
                                child: FittedBox(
                                  child: Text(
                                    "Pending",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 26,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: const RestaurantList()),
                SizedBox(
                  height: 20,
                  child: Obx(() => Text(
                        Get.find<EventController>()
                            .filteredEvents
                            .value
                            .length
                            .toString(),
                        style: const TextStyle(color: Colors.red),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
