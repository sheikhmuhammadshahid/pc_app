import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pc_app/constants.dart';
import 'package:pc_app/models/Event.dart';
import 'package:pc_app/models/memberModel.dart';

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
  String? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: careem,
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
        child: Column(
          children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 600,
                    width: MediaQuery.of(context).size.width * 0.25,
                    color: const Color.fromARGB(255, 240, 227, 202),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 28.0,
                          right: 28.0,
                          top: 15.0,
                          bottom: 28.0,
                        ),
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
                            getTextInputField1(teamName, 'Enter team name'),
                            const SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField(
                              validator: (value) {
                                if (value == '' || value == null) {
                                  return 'select event type!';
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
                            getTextInputField1(memberName, 'Enter name'),
                            const SizedBox(
                              height: 10,
                            ),
                            getTextInputField1(regNo, 'Enter Regno'),
                            const SizedBox(
                              height: 10,
                            ),
                            getTextInputField1(phone, 'Enter phone'),
                            const SizedBox(
                              height: 10,
                            ),
                            getTextInputField1(semester, 'Enter semester'),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: careem,
                                fixedSize: const Size(150, 40),
                              ),
                              onPressed: () {
                                List<MemberDetail> data = membersAdded
                                    .where((element) =>
                                        element.teamName ==
                                        teamName.text.trim())
                                    .toList();
                                if (data.isEmpty) {
                                  membersAdded.add(
                                      MemberDetail(teamName.text.trim(), []));
                                  data = [];
                                  data.add(
                                      MemberDetail(teamName.text.trim(), []));
                                }

                                if (membersAdded[membersAdded.indexWhere(
                                          (element) =>
                                              element.teamName ==
                                              data[0].teamName,
                                        )]
                                            .members
                                            .length <
                                        int.parse(noOfteams ?? '0') ||
                                    membersAdded[membersAdded.indexWhere(
                                      (element) =>
                                          element.teamName == data[0].teamName,
                                    )]
                                        .members
                                        .isEmpty) {
                                  membersAdded[membersAdded.indexWhere(
                                    (element) =>
                                        element.teamName == data[0].teamName,
                                  )]
                                      .members
                                      .add(member(
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
                                setState(() {});
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
                          ],
                        ),
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
                                              child: Center(
                                                child: ListTile(
                                                  leading: const CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        Colors.teal,
                                                  ),
                                                  trailing: GestureDetector(
                                                    onTap: () {
                                                      membersAdded[indx]
                                                          .members
                                                          .remove(memberDetail
                                                              .members[index]);
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    memberDetail
                                                        .members[index].name,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    '${memberDetail.members[index].aridNo}\n${memberDetail.members[index].phoneNo}',
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
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
