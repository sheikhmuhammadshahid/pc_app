import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pc_app/models/Event.dart';
import 'package:file_picker/file_picker.dart';

class AddQuestionsScreen extends StatefulWidget {
  eventss event;
  AddQuestionsScreen({super.key, required this.event});

  @override
  State<AddQuestionsScreen> createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  List<List<String>> excelDataList = [];
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
        if (bytes != null) {
          var excel = Excel.decodeBytes(bytes.toList());
          for (var table in excel.tables.keys) {
            print(table); //sheet Name
            print(excel.tables[table]!.maxCols);
            print(excel.tables[table]!.maxRows);
            for (var row in excel.tables[table]!.rows) {
              List<String> rowData = [];
              for (var cell in row) {
                if (cell != null) {
                  rowData.add(cell.value.toString());
                }
              }
              excelDataList.add(rowData);
            }
          }
        } else {
          EasyLoading.showToast('There is some issue while reading excel');
        }
        print('s');
        Get.back();
        setState(() {});
      }
    } catch (e) {
      EasyLoading.show(status: e.toString(), dismissOnTap: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.type),
        actions: [
          ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const Row(
                      children: [
                        Text(
                            'Question | opt1 | opt2 | opt3 | opt4 | correct | type | eventId')
                      ],
                    ),
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
              child: const Text('Read Questions'))
        ],
      ),
      body: ListView.builder(
        itemCount: excelDataList.length,
        itemBuilder: (context, index) => Card(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 35, left: 25, bottom: 20),
                child: Column(
                    children: List.generate(excelDataList[index].length,
                        (indes) => Text(excelDataList[index][indes]))),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text((index + 1).toString()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
