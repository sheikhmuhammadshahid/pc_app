import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pc_app/constants.dart';
import 'package:pc_app/models/Event.dart';
import 'package:pc_app/models/memberModel.dart';
import 'package:pc_app/screens/AddEvent/AddQuestions.dart';

import '../../Apis/ApisFunctions.dart';
import '../../models/TeamModel.dart';

class AddMembersScreen extends StatefulWidget {
  eventss event;
  AddMembersScreen({super.key, required this.event});

  @override
  State<AddMembersScreen> createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  TextEditingController teamName = TextEditingController();
  String? noOfteams;
  TextEditingController memberName = TextEditingController();
  TextEditingController regNo = TextEditingController();
  TextEditingController semester = TextEditingController();
  TextEditingController phone = TextEditingController();
  List<String> noteams = ['1', '2', '3', '4', '5'];
  List<team> membersAdded = [];
  final _formKey = GlobalKey<FormState>();
  String? image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    pickedFile = null;
  }

  getData() async {
    membersAdded = await getTeamsDetails(widget.event.id);
    setState(() {
      isLoading = false;
    });
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: careem,
              actions: [
                if (membersAdded.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          await showCupertinoModalPopup(
                            context: context,
                            builder: (context) => AlertDialog(
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      EasyLoading.show(status: 'Saving...');
                                      addTeams(
                                          eventId: widget.event.id,
                                          members: membersAdded);
                                      Get.back();
                                    },
                                    child: const Text('Yes')),
                                ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text('No'))
                              ],
                              content: const Text('Are you sure to save this?'),
                            ),
                          );
                        },
                        child: const Text('Save')),
                  ),
                ElevatedButton(
                    onPressed: () {
                      Get.to(AddQuestionsScreen(event: widget.event));
                    },
                    child: const Text('Questions')),
                const SizedBox(
                  width: 15,
                )
              ],
              title: Text(
                widget.event.type,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 600,
                    width: MediaQuery.of(context).size.width * 0.25,
                    color: const Color.fromARGB(255, 240, 227, 202),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 28.0,
                        right: 28.0,
                        //top: 15.0,
                        bottom: 28.0,
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text(
                                'Team Details',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              getTextInputField1(teamName, 'Enter team name',
                                  (value) {
                                if (value == '' || value == null) {
                                  return 'Please enter team name!';
                                }
                                return null;
                              }, 1),
                              const SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField(
                                validator: (value) {
                                  if (value == '' || value == null) {
                                    return 'Please select no of members in a team!';
                                  }
                                  return null;
                                },
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
                                  hintText: 'select no of members',
                                ),
                                value: noOfteams,
                                onChanged: (newValue) {
                                  setState(() {
                                    noOfteams = newValue;
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
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Member' s Detail",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              getTextInputField1(memberName, 'Enter name',
                                  (value) {
                                if (value == '' || value == null) {
                                  return 'Please enter name!';
                                }
                                return null;
                              }, 1),
                              const SizedBox(
                                height: 10,
                              ),
                              getTextInputField1(regNo, 'Enter Regno', (value) {
                                if (value == '' || value == null) {
                                  return 'Please enter RegNo!';
                                }
                                return null;
                              }, 1),
                              const SizedBox(
                                height: 10,
                              ),
                              getTextInputField1(phone, 'Enter phone', (value) {
                                return null;
                              }, 1),
                              const SizedBox(
                                height: 10,
                              ),
                              getTextInputField1(semester, 'Enter semester',
                                  (value) {
                                if (value == '' || value == null) {
                                  return 'Please enter semester!';
                                }
                                return null;
                              }, 1),
                              const SizedBox(
                                height: 10,
                              ),
                              FittedBox(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: pickedFile != null
                                          ? FileImage(File(pickedFile!.path))
                                          : null,
                                      child: pickedFile == null
                                          ? const Icon(
                                              Icons.person,
                                              size: 40,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(
                                      width: 9,
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await getImagePicker(context);
                                          setState(() {});
                                        },
                                        child: const Text('Pick Image'))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: careem,
                      //fixedSize: const Size(100, 40),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        List<team> data = membersAdded
                            .where((element) =>
                                element.teamName == teamName.text.trim())
                            .toList();
                        if (data.isEmpty) {
                          membersAdded.add(team(
                              teamName: teamName.text.trim(),
                              members: [],
                              TeamType: widget.event.type,
                              id: 0,
                              buzzerRound: 0,
                              buzzerWrong: 0,
                              mcqRound: 0,
                              rapidRound: 0,
                              scores: 1,
                              totalmembers: 0));
                          data = [];
                          data.add(team(
                              teamName: teamName.text.trim(),
                              members: [],
                              TeamType: widget.event.type,
                              id: 0,
                              buzzerRound: 0,
                              buzzerWrong: 0,
                              mcqRound: 0,
                              rapidRound: 0,
                              scores: 1,
                              totalmembers: 0));
                        }

                        if (membersAdded[membersAdded.indexWhere(
                                  (element) =>
                                      element.teamName == data[0].teamName,
                                )]
                                    .members
                                    .length <
                                int.parse(noOfteams ?? '0') ||
                            membersAdded[membersAdded.indexWhere(
                              (element) => element.teamName == data[0].teamName,
                            )]
                                .members
                                .isEmpty) {
                          membersAdded[membersAdded.indexWhere(
                            (element) => element.teamName == data[0].teamName,
                          )]
                              .members
                              .add(member(
                                  img: pickedFile != null
                                      ? pickedFile!.path
                                      : '',
                                  id: 0,
                                  name: memberName.text.trim(),
                                  image: '',
                                  aridNo: regNo.text.trim(),
                                  semester: semester.text.trim(),
                                  phoneNo: phone.text.trim()));
                        } else {
                          EasyLoading.showToast(
                              'can not add more members in this team',
                              dismissOnTap: true);
                        }
                        pickedFile = null;
                        setState(() {});
                      }
                    },
                    child: const Text(
                      'Add -->',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,

                    width: MediaQuery.of(context).size.width * 0.75,
                    // color: const Color.fromARGB(255, 116, 95, 31),
                    child: ListView.builder(
                        itemCount: membersAdded.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int indx) {
                          team memberDetail = membersAdded[indx];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.28,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: FittedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(memberDetail.teamName),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: memberDetail.members.length,
                                        itemBuilder: (context, index) =>
                                            Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Card(
                                              child: Stack(
                                                children: [
                                                  Row(
                                                    children: [
                                                      if (memberDetail
                                                              .members[index]
                                                              .img !=
                                                          '') ...{
                                                        CircleAvatar(
                                                          radius: 60,
                                                          backgroundImage:
                                                              FileImage(File(
                                                                  memberDetail
                                                                      .members[
                                                                          index]
                                                                      .img)),
                                                        ),
                                                      } else
                                                        Container(
                                                            height: 150,
                                                            width: 150,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .grey,
                                                                    shape: BoxShape
                                                                        .circle),
                                                            child: ClipOval(
                                                              child:
                                                                  Image.network(
                                                                imageAddress +
                                                                    memberDetail
                                                                        .members[
                                                                            index]
                                                                        .image,
                                                                fit: BoxFit
                                                                    .cover,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child;
                                                                  }
                                                                  return Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      value: loadingProgress.expectedTotalBytes !=
                                                                              null
                                                                          ? loadingProgress.cumulativeBytesLoaded /
                                                                              loadingProgress.expectedTotalBytes!
                                                                          : null,
                                                                    ),
                                                                  );
                                                                },
                                                                errorBuilder: (context,
                                                                        error,
                                                                        stackTrace) =>
                                                                    const Icon(
                                                                  Icons.person,
                                                                  size: 30,
                                                                ),
                                                              ),
                                                            )),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              memberDetail
                                                                  .members[
                                                                      index]
                                                                  .name,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${memberDetail.members[index].aridNo}\n${memberDetail.members[index].phoneNo}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          membersAdded[indx]
                                                              .members
                                                              .remove(memberDetail
                                                                      .members[
                                                                  index]);
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
  }
}
