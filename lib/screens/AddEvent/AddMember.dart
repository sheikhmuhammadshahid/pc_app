import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pc_app/constants.dart';
import 'package:pc_app/models/Event.dart';
import 'package:pc_app/models/memberModel.dart';
import 'package:pc_app/screens/AddEvent/AddQuestions.dart';

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
  List<MemberDetail> membersAdded = [];
  final _formKey = GlobalKey<FormState>();
  String? image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickedFile = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: careem,
        actions: [
          ElevatedButton(
              onPressed: () {
                Get.to(AddQuestionsScreen(event: widget.event));
              },
              child: const Text('Questions'))
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        }),
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
                          items: noteams
                              .map<DropdownMenuItem<String>>((String value) {
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
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        getTextInputField1(regNo, 'Enter Regno', (value) {
                          if (value == '' || value == null) {
                            return 'Please enter RegNo!';
                          }
                          return null;
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        getTextInputField1(phone, 'Enter phone', (value) {
                          return null;
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        getTextInputField1(semester, 'Enter semester', (value) {
                          if (value == '' || value == null) {
                            return 'Please enter semester!';
                          }
                          return null;
                        }),
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
                  List<MemberDetail> data = membersAdded
                      .where(
                          (element) => element.teamName == teamName.text.trim())
                      .toList();
                  if (data.isEmpty) {
                    membersAdded.add(MemberDetail(teamName.text.trim(), []));
                    data = [];
                    data.add(MemberDetail(teamName.text.trim(), []));
                  }

                  if (membersAdded[membersAdded.indexWhere(
                            (element) => element.teamName == data[0].teamName,
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
                            id: 0,
                            name: memberName.text.trim(),
                            image: pickedFile != null ? pickedFile!.path : '',
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
                'Add',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
                    MemberDetail memberDetail = membersAdded[indx];
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
                                    MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: memberDetail.members.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Card(
                                        child: Stack(
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 60,
                                                  backgroundImage: memberDetail
                                                              .members[index]
                                                              .image !=
                                                          ''
                                                      ? FileImage(File(
                                                          memberDetail
                                                              .members[index]
                                                              .image))
                                                      : null,
                                                  child: memberDetail
                                                              .members[index]
                                                              .image !=
                                                          ''
                                                      ? null
                                                      : const Icon(
                                                          Icons.person,
                                                          size: 30,
                                                        ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        memberDetail
                                                            .members[index]
                                                            .name,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                  onPressed: () {
                                                    membersAdded[indx]
                                                        .members
                                                        .remove(memberDetail
                                                            .members[index]);
                                                    setState(() {});
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete)),
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

class MemberDetail {
  String teamName = '';
  List<member> members = [];
  MemberDetail(this.teamName, this.members);
}
