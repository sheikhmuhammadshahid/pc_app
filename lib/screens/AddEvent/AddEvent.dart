import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_competition_flutter/Client/ApiClient.dart';
import 'package:quiz_competition_flutter/controllers/EventsController.dart';
import 'package:quiz_competition_flutter/main.dart';
import '../../constants.dart';
import '../../models/EventModel.dart';
//import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  String? eventtype;
  String? noOfTeams;
  TextEditingController dateTimeController =
      TextEditingController(text: "null");
  DateTime? dateTime = DateTime.now();
  List<String> events = ['Basic', 'Advance', 'Pro'];
  List<String> noteams = ['2', '3', '4'];
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      alignment: Alignment.topCenter,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInCirc,
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          //color: const Color.fromARGB(255, 177, 225, 202),
          width: context.width * 1,
          height: context.height * 0.7,

          child: Material(
            elevation: 1.0,
            color: const Color.fromARGB(255, 246, 246, 241),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 30, right: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Add Event',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FittedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 250,
                            height: 80,
                            child: DropdownButtonFormField(
                              validator: (value) {
                                if (value == '' || value == null) {
                                  return 'select event type!';
                                }
                                return null;
                              },
                              dropdownColor:
                                  const Color.fromARGB(255, 246, 246, 241),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                hintText: 'Select Event Type',
                              ),
                              value: eventtype,
                              onChanged: (newValue) {
                                setState(() {
                                  eventtype = newValue.toString();
                                });
                              },
                              items: events.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 250,
                            height: 80,
                            child: DropdownButtonFormField(
                              validator: (value) {
                                if (value == '' || value == null) {
                                  return 'select total no.of teams!';
                                }
                                return null;
                              },
                              dropdownColor:
                                  const Color.fromARGB(255, 246, 246, 241),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                hintText: 'Select No Of Teams',
                              ),
                              value: noOfTeams,
                              onChanged: (newValue) {
                                setState(() {
                                  noOfTeams = newValue.toString();
                                });
                              },
                              items: noteams.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FittedBox(
                      child: Container(
                        height: 80,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 245, 240, 227),
                        ),
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Pick Event Date",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () async {
                                    dateTime = await showDatePicker(
                                      context: context,
                                      initialDate: dateTime ?? DateTime.now(),
                                      firstDate: DateTime
                                          .now(), // Set the first date that can be selected
                                      lastDate: DateTime(
                                          2101), // Set the last date that can be selected
                                    );

                                    setState(() {
                                      dateTimeController.text =
                                          dateTime.toString().split(' ')[0];
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 240, 227, 202),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: dateTimeController.text == "null"
                                          ? const Icon(
                                              Icons.calendar_month_rounded,
                                              color: Colors.black,
                                            )
                                          : Text(
                                              dateTimeController.text,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
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
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: careem,
                        fixedSize: const Size(150, 40),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          EventModel e = EventModel(
                              id: 0,
                              date: dateTime.toString().split(' ')[0],
                              type: eventtype!,
                              status: 'created',
                              tTeams: 0);
                          await saveEvent(event: e);
                          Get.find<EventController>().eventssList.add(e);
                          Get.find<EventController>().filteredEvents.add(e);
                          Get.back();
                        }
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
