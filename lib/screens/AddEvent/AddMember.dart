import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:quiz_competition_flutter/Client/ApiClient.dart';

import '../../AddQuestion.dart';
import '../../constants.dart';
import '../../models/EventModel.dart';
import '../../models/MemberModel.dart';
import '../../models/OnGoingTeamsModel.dart';
import '../../models/TeamModel.dart';

class AddMembersScreen extends StatefulWidget {
  EventModel event;
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
  List<OnGoingTeams> membersAdded = [];
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
    membersAdded = await getTeamsDetails(eventId: widget.event.id);
    setState(() {
      isLoading = false;
    });
  }

  bool isLoading = true;
  bool isMobile = false;
  bool isChanges = false;

  saveTeams() async {
    try {
      EasyLoading.show(status: 'Saving...');
      await addTeams(members: membersAdded, eventId: widget.event.id ?? 0);
      EasyLoading.dismiss();
      Get.back();
    } catch (e) {}
  }

  showConfirmationDialogue({required bool toQuestionScreen}) async {
    return await showCupertinoModalPopup(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, toQuestionScreen ? false : true);
              },
              child: const Text('Exit')),
          ElevatedButton(
              onPressed: () async {
                await saveTeams();
                if (!toQuestionScreen) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Save?'))
        ],
        content: const Text(
            'You have some changes to save.\n Please make sure to save them first'),
        icon: Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                icon: const Icon(Icons.cancel))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isMobile = context.width <= 600;
    return WillPopScope(
        onWillPop: () async {
          if (isChanges) {
            return await showConfirmationDialogue(toQuestionScreen: false);
          } else {
            return true;
          }
        },
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: careem,
                  actions: const [],
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
                  //physics: const NeverScrollableScrollPhysics(),
                  //scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Row(
                        children: [
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
                                                await saveTeams();
                                              },
                                              child: const Text('Yes')),
                                          ElevatedButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text('No'))
                                        ],
                                        content: const Text(
                                            'Are you sure to save this?'),
                                      ),
                                    );
                                  },
                                  child: const Text('Save')),
                            ),
                          ElevatedButton(
                              onPressed: () async {
                                if (!isChanges) {
                                  Get.to(
                                      AddQuestionsScreen(event: widget.event));
                                } else {
                                  bool res = await showConfirmationDialogue(
                                      toQuestionScreen: true);
                                  if (res) {
                                    Get.to(AddQuestionsScreen(
                                        event: widget.event));
                                  }
                                }
                              },
                              child: const Text('Questions')),
                          const SizedBox(
                            width: 15,
                          )
                        ],
                      ),
                      if (context.width <= 600)
                        ...getWidgets()
                      else
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: getWidgets(),
                          ),
                        ),
                    ],
                  ),
                ),
              ));
  }

  List<Widget> getWidgets() {
    return [
      Container(
        height: isMobile
            ? context.height * 0.4
            : MediaQuery.of(context).size.height,
        width:
            isMobile ? context.width : MediaQuery.of(context).size.width * 0.25,
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
                  getTextInputField1(teamName, 'Enter team name', (value) {
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
                        noOfteams = newValue.toString();
                      });
                    },
                    items:
                        noteams.map<DropdownMenuItem<String>>((String value) {
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
                  getTextInputField1(memberName, 'Enter name', (value) {
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
                  getTextInputField1(semester, 'Enter semester', (value) {
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
            List<OnGoingTeams> data = membersAdded
                .where(
                    (element) => element.team.teamName == teamName.text.trim())
                .toList();
            // TeamModel? t;
            if (data.isEmpty) {
              membersAdded.add(
                OnGoingTeams(
                    members: [],
                    team: TeamModel(
                        teamName: teamName.text.trim(),
                        // members: [],
                        teamType: widget.event.type,
                        id: 0,
                        buzzerRound: 0,
                        buzzerWrong: 0,
                        mcqRound: 0,
                        rapidRound: 0,
                        scores: 1,
                        totalMembers: 0
                        // totalmembers: 0
                        ),
                    teamId: -1),
              );
              data = [];
              data.add(OnGoingTeams(
                  members: [],
                  team: TeamModel(
                      teamName: teamName.text.trim(),
                      // members: [],
                      teamType: widget.event.type,
                      id: 0,
                      buzzerRound: 0,
                      buzzerWrong: 0,
                      mcqRound: 0,
                      rapidRound: 0,
                      scores: 1,
                      totalMembers: 0),
                  teamId: -1));
            }

            if (membersAdded[membersAdded.indexWhere(
                      (element) =>
                          element.team.teamName == data[0].team.teamName,
                    )]
                        .members
                        .length <
                    int.parse(noOfteams ?? '0') ||
                membersAdded[membersAdded.indexWhere(
                  (element) => element.team.teamName == data[0].team.teamName,
                )]
                    .members
                    .isEmpty) {
              membersAdded[membersAdded.indexWhere(
                (element) => element.team.teamName == data[0].team.teamName,
              )]
                  .members
                  .add(MemberModel(
                      img: '',
                      // img: pickedFile != null ? pickedFile!.path : '',
                      id: 0,
                      name: memberName.text.trim(),
                      image: '',
                      aridNo: regNo.text.trim(),
                      semester: semester.text.trim(),
                      phoneNo: phone.text.trim()));
            } else {
              EasyLoading.showToast('can not add more members in this team',
                  dismissOnTap: true);
            }
            setState(() {
              isChanges = true;
            });
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

        width:
            isMobile ? context.width : MediaQuery.of(context).size.width * 0.75,
        // color: const Color.fromARGB(255, 116, 95, 31),
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: membersAdded.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int indx) {
              OnGoingTeams memberDetail = membersAdded[indx];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: isMobile
                      ? context.width
                      : MediaQuery.of(context).size.width * 0.75,
                  child: FittedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(memberDetail.team.teamName),
                            IconButton(
                                onPressed: () async {
                                  await showCupertinoDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      icon: Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              await deleteTeam(
                                                  teamId:
                                                      memberDetail.team.id ??
                                                          0);
                                              membersAdded.removeAt(indx);
                                              Get.back();
                                              setState(() {
                                                // isChanges = true;
                                              });
                                            },
                                            child: const Text('Yes')),
                                        ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text('No'))
                                      ],
                                      content: const Text(
                                          'Are you sure to delete the team with all the members of it?'),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: isMobile
                              ? context.width
                              : MediaQuery.of(context).size.width * 0.6,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: memberDetail.members.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: isMobile
                                    ? context.width * 0.9
                                    : MediaQuery.of(context).size.width * 0.3,
                                child: Card(
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          if (memberDetail
                                                  .members[index].image !=
                                              '') ...{
                                            CircleAvatar(
                                              radius: 60,
                                              backgroundImage: FileImage(File(
                                                  memberDetail
                                                      .members[index].image)),
                                            ),
                                          } else
                                            Container(
                                                height: 150,
                                                width: 150,
                                                decoration: const BoxDecoration(
                                                    color: Colors.grey,
                                                    shape: BoxShape.circle),
                                                child: ClipOval(
                                                  child: Image.network(
                                                    '',
                                                    // imageAddress +
                                                    //     memberDetail
                                                    //         .members[index]
                                                    //         .image,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
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
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  memberDetail
                                                      .members[index].name,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  '${memberDetail.members[index].aridNo}\n${memberDetail.members[index].phoneNo}',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                            onPressed: () async {
                                              if (memberDetail
                                                      .members[index].id !=
                                                  0) {
                                                deleteMemberApi(
                                                    memberId: memberDetail
                                                        .members[index].id);
                                              }
                                              membersAdded[indx].members.remove(
                                                  memberDetail.members[index]);

                                              setState(() {
                                                // isChanges = true;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            )),
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
    ];
  }
}
