import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
// import 'package:quiz_competition_client/quiz_competition_client.dart';
import 'package:quiz_competition_flutter/Client/ClientDetails.dart';
import 'package:quiz_competition_flutter/EventController.dart';
import 'package:quiz_competition_flutter/main.dart';

import 'Client/ApiClient.dart';
import 'constant.dart';
import 'models/EventModel.dart';
import 'models/Question.dart';

class AddQuestionsScreen extends StatefulWidget {
  EventModel event;
  AddQuestionsScreen({super.key, required this.event});

  @override
  State<AddQuestionsScreen> createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  List<Question> excelDataList = [];

  bool isChanged = false;

  @override
  initState() {
    super.initState();
    getQues();
  }

  getQues() async {
    excelDataList = await getQuestionss(eventId: widget.event.id ?? 0);
    setState(
      () {
        isGettingquestions = false;
      },
    );
  }

  saveQuestionss() async {
    try {
      EasyLoading.show(status: 'Saving Questions...');
      var res = await saveQuestions(
          questions: excelDataList, eventId: widget.event.id);
      setState(() {
        isChanged = false;
      });
      EasyLoading.dismiss();
      EasyLoading.showToast(res.message);
    } catch (e) {}
  }

  bool isGettingquestions = true;
  pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['xlx', 'xlxs', 'xlsx'],
      );
      if (result != null) {
        File file = File(result.files.first.path!);
        var bytes = await file.readAsBytes();
        var excel = Excel.decodeBytes(bytes.toList());
        for (var table in excel.tables.keys) {
          print(table); //sheet Name
          if (excel.tables[table]!.maxColumns == 8) {
            print(excel.tables[table]!.maxRows);
            int i = 0;
            for (var row in excel.tables[table]!.rows) {
              if (i != 0) {
                Question question = Question(
                    id: 0,
                    ques: row[0] == null ? '' : row[0]!.value.toString(),
                    opt1: row[1] == null ? '' : row[1]!.value.toString(),
                    opt2: row[2] == null ? '' : row[2]!.value.toString(),
                    opt3: row[3] == null ? '' : row[3]!.value.toString(),
                    opt4: row[4] == null ? '' : row[4]!.value.toString(),
                    answer: row[5] == null ? '' : row[5]!.value.toString(),
                    type: row[6] == null ? '' : row[6]!.value.toString(),
                    eventId: (row[7] == null
                        ? -1
                        : double.parse(row[7]!.value.toString()).toInt()));

                excelDataList.add(question);
              }
              i++;
            }
          } else {
            EasyLoading.show(
                dismissOnTap: true,
                status:
                    'Data is not in correct formate.\n columns should be of length 8');
          }
        }
        print('s');
        Get.back();
        setState(() {});
      }
    } catch (e) {
      EasyLoading.show(status: e.toString(), dismissOnTap: true);
    }
  }

  final _formKey = GlobalKey<FormState>();
  OnGoingEventController questionController =
      Get.find<OnGoingEventController>();
  @override
  Widget build(BuildContext context) {
    // questionController.gval.value = 0;
    return WillPopScope(
      onWillPop: () async {
        if (isChanged) {
          return await showCupertinoModalPopup(
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Exit')),
                ElevatedButton(
                    onPressed: () async {
                      await saveQuestionss();
                      Navigator.pop(context, true);
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
        } else {
          return true;
        }
      },
      child: isGettingquestions
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(
                actions: [
                  if (isChanged)
                    ElevatedButton(
                        onPressed: () async {
                          await showCupertinoModalPopup(
                            context: context,
                            builder: (context) => AlertDialog(
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        await saveQuestionss();
                                        // Get.back();
                                      } catch (e) {
                                        print(e);
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Yes')),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No'))
                              ],
                              content: const Text('Are you sure to save this?'),
                            ),
                          );
                        },
                        child: const Text('Save'))
                ],
                // title: Text(widget.event.type),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    FittedBox(
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: const Text(
                                        'Question | opt1 | opt2 | opt3 | opt4 | correct | type | eventId'),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            await pickFile();
                                          },
                                          child: const Text('Pick file'))
                                    ],
                                    title: const Text(
                                        'Make sure your excel data should be like this!'),
                                    icon: Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            icon: const Icon(Icons.cancel))),
                                  ),
                                );
                              },
                              child: const Text('Read Questions')),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                quesController.text = opt1Controller.text =
                                    opt2Controller.text = opt3Controller.text =
                                        opt4Controller.text = '';
                                questionController.gval.value = 0;
                                await getAddQuestionDialogue(false, 0);
                              },
                              child: const Text('Add ')),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: ListView.builder(
                          itemCount: excelDataList.length,
                          itemBuilder: (context, index) {
                            Question question = excelDataList[index];
                            return Card(
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 35, left: 25, bottom: 20),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Question: ${question.ques}"),
                                          Text("Option1: ${question.opt1}"),
                                          Text("Option2: ${question.opt2}"),
                                          Text("Option3: ${question.opt3}"),
                                          Text("Option4: ${question.opt4}"),
                                          Text("Answer: ${question.answer}"),
                                          Text("Type: ${question.type}")
                                        ]),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              questionController
                                                  .gval.value = question.opt1 ==
                                                      question.answer
                                                  ? 1
                                                  : question.opt2 ==
                                                          question.answer
                                                      ? 2
                                                      : question.opt3 ==
                                                              question.answer
                                                          ? 3
                                                          : 4;

                                              quesController.text =
                                                  question.ques;
                                              opt1Controller.text =
                                                  question.opt1;
                                              opt2Controller.text =
                                                  question.opt2;
                                              opt3Controller.text =
                                                  question.opt3;
                                              opt4Controller.text =
                                                  question.opt4;
                                              context
                                                  .read<ClientProvider>()
                                                  .changeQuestionType(
                                                      type: question.type);
                                              await getAddQuestionDialogue(
                                                  true, index);
                                            },
                                            icon: const Icon(
                                                Icons.edit_calendar_outlined)),
                                        IconButton(
                                            onPressed: () async {
                                              excelDataList.remove(question);

                                              setState(() {
                                                isChanged = true;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    color: Colors.teal,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text((index + 1).toString()),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              )),
    );
  }

  String? type;
  getAddQuestionDialogue(bool isEdit, int index) async {
    if (!isEdit) {
      context.read<ClientProvider>().changeQuestionType(type: null);
    }
    return await showCupertinoDialog(
      context: context,
      builder: (context) => Form(
        key: _formKey,
        child: AlertDialog(
          title: getTextInputField1(quesController, 'Question', (v) {
            if (v == '') {
              return 'Please enter question.';
            }
            return null;
          }, 4),
          content: Wrap(
            children: [
              getField(
                  value: 1,
                  controller: opt1Controller,
                  lable: 'Option 1',
                  validator: true),
              getField(
                  controller: opt2Controller,
                  lable: 'Option 2',
                  value: 2,
                  validator: true),
              getField(
                  controller: opt3Controller,
                  lable: 'Option 3',
                  value: 3,
                  validator: true),
              getField(
                  controller: opt4Controller,
                  lable: 'Option 4',
                  value: 4,
                  validator: true),
              // getField(
              //     controller: TextEditingController(
              //         text: context.watch<ClientProvider>().questionType),
              //     lable: 'select type!',
              //     value: 4,
              //     isEnabled: false,
              //     validator: true),
              SizedBox(
                width: 300,
                child: DropdownButtonFormField<String>(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  validator: (value) {
                    if (context.read<ClientProvider>().questionType != null) {
                      return null;
                    }
                    return 'Please select question type!';
                  },
                  //hint: const Text('select type.'),
                  value: context.watch<ClientProvider>().questionType,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 240, 227, 202),
                    hintText: 'select type!',

                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    //focusColor: Colors.black,
                    //focusedBorder: const OutlineInputBorder(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Buzzer',
                      child: Text('Buzzer'),
                    ),
                    DropdownMenuItem(
                      value: 'Rapid',
                      child: Text('Rapid'),
                    ),
                    DropdownMenuItem(
                      value: 'MCQ',
                      child: Text('MCQ'),
                    )
                  ],
                  onChanged: (value) => context
                      .read<ClientProvider>()
                      .changeQuestionType(type: value!),
                ),
              )
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (questionController.gval.value == 0) {
                      EasyLoading.showToast('Please select a correct answer!');
                    } else {
                      int value = questionController.gval.value;
                      Question question = Question(
                          id: isEdit ? excelDataList[index].id : 0,
                          ques: quesController.text.trim(),
                          opt1: opt1Controller.text.trim(),
                          opt2: opt2Controller.text.trim(),
                          opt3: opt3Controller.text.trim(),
                          opt4: opt4Controller.text.trim(),
                          eventId: 1,
                          type:
                              context.read<ClientProvider>().questionType ?? '',
                          answer: value == 1
                              ? opt1Controller.text.trim()
                              : value == 2
                                  ? opt2Controller.text.trim()
                                  : value == 3
                                      ? opt3Controller.text.trim()
                                      : opt4Controller.text.trim());
                      if (isEdit) {
                        excelDataList.removeAt(index);
                        excelDataList.insert(index, question);
                      } else {
                        isChanged = true;
                        excelDataList.add(question);
                      }
                      Navigator.pop(context);
                      setState(() {});
                      if (isEdit) {
                        isChanged = true;
                        // saveQuestions(questions: excelDataList);
                      }
                    }
                  }
                },
                child: Text(isEdit ? "Edit" : 'Add'))
          ],
          icon: Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  // Get.back();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel)),
          ),
        ),
      ),
    );
  }

  Padding getField(
      {required TextEditingController controller,
      required String lable,
      int maxLine = 1,
      bool isEnabled = true,
      required int value,
      validator}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: SizedBox(
        width: 310,
        child: FittedBox(
          child: Row(
            children: [
              if (value != -1 && isEnabled)
                Obx(
                  () => Radio<int>(
                    value: value,
                    groupValue: questionController.gval.value,
                    onChanged: (valu) {
                      questionController.gval.value = valu!;
                    },
                  ),
                ),
              SizedBox(
                width: 300,
                child: getTextInputField1(
                    controller,
                    lable,
                    validator
                        ? (v) {
                            if (v == '') {
                              return 'Please enter $lable';
                            }
                            return null;
                          }
                        : null,
                    maxLine,
                    isEnabled: isEnabled),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
